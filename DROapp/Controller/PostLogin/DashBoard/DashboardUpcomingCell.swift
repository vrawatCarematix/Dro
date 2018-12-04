//
//  DashboardUpcomingCell.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import FoldingCell

class DashboardUpcomingCell: FoldingCell {

    //MARK:- Outlet
    @IBOutlet var imgHalf: UIImageView!
    @IBOutlet var bottomConstrient: NSLayoutConstraint!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var labelDueToday: UILabel!
    @IBOutlet weak var upperView: RotatedView!
    @IBOutlet weak var batchNumber: UILabel!
    @IBOutlet weak var buttonCollapse: UIButton!
    @IBOutlet weak var expendTable: UITableView!
    
    @IBOutlet var openCell: UIButton!
    
    //MARK:- Variables

    var maximumHeight = CGFloat(0)
    var upcomingArray = [SurveyScheduleDatabaseModel]()

    //MARK:- View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        batchNumber.setCustomFont()
        labelDueToday.setCustomFont()
        DispatchQueue.main.async {
            self.batchNumber.layer.cornerRadius = self.batchNumber.frame.size.width / 2
        }
        foregroundView.layer.borderWidth = 1
        foregroundView.layer.borderColor = UIColor(red: 0.9137, green: 0.9373, blue: 0.9490, alpha: 1.0).cgColor
        batchNumber.clipsToBounds = true
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            containerView.layer.cornerRadius = 15.0
            upperView.layer.cornerRadius = 15.0
        }else{
            containerView.layer.cornerRadius = 7.0
            upperView.layer.cornerRadius = 7.0
        }
        self.containerView.clipsToBounds = true
        self.backViewColor = .white

        expendTable.dataSource = self
        expendTable.delegate = self
        self.expendTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        // let shadowPath = UIBezierPath(roundedRect: upperView.bounds, cornerRadius: 3.0)
        upperView.layer.masksToBounds = true
      //  self.itemCount = userSessionArray.count + 3
        NSLayoutConstraint.deactivate([bottomConstrient])
        // Initialization code
    }
    
    func setText()  {
        if upcomingArray.count == 0 {
            batchNumber.isHidden = true
        }else{
            batchNumber.isHidden = false
            batchNumber.text = "\(upcomingArray.count)"
        }
        self.itemCount = (min(( upcomingArray.count + 3 ) , 6 ) )

        expendTable.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.expendTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    var rect = self.expendTable.frame
                    rect.origin.y = 0
                    heightConstant.constant = newSize.height
                    if maximumHeight > 10 && newSize.height > maximumHeight {
                        heightConstant.constant = maximumHeight
                        rect.size.height = maximumHeight
                    }else{
                        heightConstant.constant = newSize.height
                        rect.size.height = newSize.height
                    }
                    self.itemCount =  max(Int(heightConstant.constant / foregroundView.frame.size.height) + 2 , 3 )

                    self.expendTable.frame = rect
                    self.expendTable.layer.cornerRadius = 5
                    self.expendTable.clipsToBounds = true
                }
            }
        }
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        var durations = [kExpandDuration, kExpandDuration]
        for _ in  0..<(itemCount) {
            durations.append(kExpandDuration)
        }
        return durations[itemIndex]
    }
    
    @IBAction func expendCell(_ sender: UIButton) {
        let dict = [kOpen : Collapse.open , kCell : DashboardCellType.Upcoming] as [String : Any]
        
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }
    
    @objc func getSurvey(sender : UIButton){
        let session = upcomingArray[sender.tag]
        
        if session.scheduleType == "UNSCHEDULED" {
            if let unscheduled = DatabaseHandler.getUncheduledIncompleteSurvey(surveyId: session.surveyID ?? 0).first {
                let droHomeController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.DroHomeController) as! DroHomeController
                droHomeController.survey = unscheduled
                if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                    visibleController.navigationController?.pushViewController(droHomeController, animated: true)
                }
            }
        }else if let sessionId = session.surveySessionId {
            var survey = SurveySubmitModel()
            if let surveyModel = DatabaseHandler.getSurveyOfSession(surveySessionId:sessionId ){
                survey = surveyModel
            }else{
                survey = DatabaseHandler.getSurvey(surveyId: session.surveyID ?? 0)
            }
            survey.surveySessionId = session.surveySessionId
            survey.scheduledDate = session.surveyDate
            survey.scheduledStartTime = session.startTime
            survey.scheduledEndTime = session.endTime
            survey.programSurveyId = session.programSurveyId
            survey.progressStatus = session.progressStatus
            if survey.unscheduled == 1 {
                survey.scheduleType = "SCHEDULED"
                survey.unscheduled = 0
            }else{
                survey.scheduleType = session.scheduleType
            }
            survey.declined = 0
            if let status = survey.progressStatus , status.lowercased() == "STARTED".lowercased()  {
                let questionnaireController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.QutionnaireController) as! QuestionnaireController
                questionnaireController.survey = survey
                if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                    visibleController.navigationController?.pushViewController(questionnaireController, animated: true)
                }
            }else{
                let droHomeController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.DroHomeController) as! DroHomeController
                droHomeController.survey = survey
                if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                    visibleController.navigationController?.pushViewController(droHomeController, animated: true)
                }
            }
        }
    }
}

//MARK:- UITableViewDataSource

extension DashboardUpcomingCell : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.allowsSelection = true

        if upcomingArray.count == 0 {
            return 1
        }else{
            return upcomingArray.count
        }
        //return userSessionArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.UpcomingRowCell, for: indexPath) as? UpcomingRowCell
        cell?.selectionStyle = .none
        if upcomingArray.count == 0 {
           cell?.showAlert()
            tableView.allowsSelection = false
            cell?.buttonStart.isUserInteractionEnabled = false

        }else{
            cell?.upcoming = upcomingArray[indexPath.row]
            cell?.setText()
            tableView.allowsSelection = true
            cell?.buttonStart.isUserInteractionEnabled = true
            cell?.buttonStart.tag = indexPath.row
            cell?.buttonStart.addTarget(self, action: #selector(getSurvey), for: .touchUpInside)

        }
       
        return cell!
    }
}

//MARK:- UITableViewDelegate

extension DashboardUpcomingCell : UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.UpcomingHeaderCell) as? UpcomingHeaderCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
}

