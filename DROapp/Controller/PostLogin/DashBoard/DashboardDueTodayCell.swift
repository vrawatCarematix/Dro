//
//  DashboardRowCellCell.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import FoldingCell
class DashboardDueTodayCell: FoldingCell {
    
    //MARK:- Outlets
    @IBOutlet var bottomConstrient: NSLayoutConstraint!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var labelDueToday: UILabel!
    @IBOutlet weak var batchNumber: UILabel!
    @IBOutlet weak var buttonCollapse: UIButton!
    @IBOutlet weak var expendTable: UITableView!
    @IBOutlet var imgHalf: UIImageView!
    @IBOutlet var buttonOpen: UIButton!
    
    //MARK:- Variables
    
    var maximumHeight = CGFloat(0)
    var dueTodayArray = [SurveyScheduleDatabaseModel]()

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
        foregroundView.layer.masksToBounds = true

        if UIDevice.current.userInterfaceIdiom == .pad{
            foregroundView.layer.cornerRadius = 15.0
            containerView.layer.cornerRadius = 15.0
        }else{
            containerView.layer.cornerRadius = 7.0
            foregroundView.layer.cornerRadius = 7.0

        }
        self.backViewColor = .white
        expendTable.dataSource = self
        expendTable.delegate = self
        self.expendTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.itemCount = 2
        NSLayoutConstraint.deactivate([bottomConstrient])
        // Initialization code
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
    func setText()  {
        if dueTodayArray.count == 0 {
            batchNumber.isHidden = true
        }else{
            batchNumber.isHidden = false
            batchNumber.text = "\(dueTodayArray.count)"
      }
        expendTable.reloadData()
    }
    
    @IBAction func expandCell(_ sender: UIButton) {
       
        let dict = [kOpen : Collapse.open , kCell : DashboardCellType.DueToday] as [String : Any]
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }    
}

//MARK:- UITableViewDataSource

extension DashboardDueTodayCell : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dueTodayArray.count == 0 {
            return 1
        }else{
            return dueTodayArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DueTodayRowCell, for: indexPath) as? DueTodayRowCell
        cell?.selectionStyle = .none
        if dueTodayArray.count == 0 {
            cell?.showAlert()
            tableView.allowsSelection = false
        }else{
            cell?.dueToday = dueTodayArray[indexPath.row]
            cell?.setText()
            tableView.allowsSelection = true
        }
        return cell!
    }
}

//MARK:- UITableViewDelegate

extension DashboardDueTodayCell : UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DueTodayHeaderCell) as? DueTodayHeaderCell
        
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
        if dueTodayArray.count == 0 {
            return
        }
        let session = dueTodayArray[indexPath.row]
        if session.scheduleType == "UNSCHEDULED" {
            let unscheduled = DatabaseHandler.getUncheduledIncompleteSurvey(surveyId: session.surveyID ?? 0)
            if unscheduled.count > 0   {
                let droHomeController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.DroHomeController) as! DroHomeController
                let survey = unscheduled[0]
                if let startTime = survey.scheduledStartTime , startTime != 0 {
                    if let startTime = survey.scheduledEndTime , startTime != 0 {
                    }else{
                        if let validity = survey.validity , validity != 0 {
                            survey.scheduledEndTime = (validity ) * 1000 + startTime
                        }
                    }
                }else{
                    var endTime = Int(Date().timeIntervalSince1970)
                    endTime  += TimeZone.current.secondsFromGMT()
                    survey.scheduledStartTime = endTime * 1000
                    if let startTime = survey.scheduledEndTime , startTime != 0 {
                    }else{
                        if let validity = survey.validity , validity != 0 {
                            survey.scheduledEndTime = ( endTime + validity ) * 1000
                        }
                    }
                }
                droHomeController.survey = survey
                if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                    visibleController.navigationController?.pushViewController(droHomeController, animated: true)
                }
            }
        }else{
            if let startTime = session.startTime {
                let localtime = Int(Date().timeIntervalSince1970) * 1000
                if startTime > localtime {
                    return
                }
            }
            if let sessionId = session.surveySessionId {
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
                let droHomeController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.DroHomeController) as! DroHomeController
                droHomeController.survey = survey
                if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                    visibleController.navigationController?.pushViewController(droHomeController, animated: true)
                }
            }
        }
    }
    
}

