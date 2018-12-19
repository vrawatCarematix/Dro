//
//  DeclineController.swift
//  DROapp
//
//  Created by Carematix on 31/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import DropDown
import LGSideMenuController

class DeclineController: DROViewController {
    
    //MARK:- Outlet
    @IBOutlet var labelHeading: UILabel!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var labelSelectedReason: UILabel!
    @IBOutlet var labelDetail: UILabel!
    
    //MARK:- Variable

    weak var droHome : DroHomeController?
    weak var questionController : QuestionnaireController?

    var surveyArray = [SurveySubmitModel]()
    var declinedArray = [DeclinedModel]()
    let chooseDecline = DropDown()
    var selectedReason = 0
    
    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.setCustomFont()
        labelDetail.setCustomFont()
        labelHeading.setCustomFont()
        labelSelectedReason.setCustomFont()
        declineButton.setCustomFont()
        declineButton.layer.cornerRadius = defaultCornerRadius
        chooseDecline.dismissMode = .onTap
        chooseDecline.direction = .any
        DropDown.appearance().textFont = labelSelectedReason.font
        getDeclineReason()
        // Do any additional setup after loading the view.
    }
    
    func getDeclineReason()  {
        self.declinedArray.removeAll()
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            CustomActivityIndicator.startAnimating( message: "Getting Data...")
            getDeclineReasonWebService { (success, response, message) in
                DispatchQueue.main.async {
                    CustomActivityIndicator.stopAnimating()
                    self.declinedArray = DatabaseHandler.getAllDeclinedReason()
                    let reasons = self.declinedArray.compactMap({ return $0.declineReason })
                    self.chooseDecline.dataSource = reasons
                    if self.declinedArray.count > 0 {
                        self.labelSelectedReason.text = self.declinedArray[self.selectedReason].declineReason
                    }
                }
            }
        }else{
            self.declinedArray = DatabaseHandler.getAllDeclinedReason()
            let reasons = self.declinedArray.compactMap({ return $0.declineReason })
            self.chooseDecline.dataSource = reasons
            if self.declinedArray.count > 0 {
                self.labelSelectedReason.text = self.declinedArray[self.selectedReason].declineReason
            }
        }
    }
    
    //MARK:- Button Action

    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func decline(_ sender: UIButton) {
        if self.declinedArray.count == 0 {
            return
        }else{
            var declinedSurveyArray = [DeclinedSurveyModel]()
            let declinedTime = ( Int(Date().timeIntervalSince1970) + TimeZone.current.secondsFromGMT() ) * 1000
            for survey in surveyArray{
                let declinedSurvey = DeclinedSurveyModel()
                declinedSurvey.userSurveySessionId = survey.surveySessionId
                declinedSurvey.declineTime = declinedTime
                declinedSurvey.declineReasonId = self.declinedArray[selectedReason].declineReasonId
                declinedSurveyArray.append(declinedSurvey)
                var _ = DatabaseHandler.updateSchedule(progressStatus: survey.progressStatus ?? "", isDeclined: 1, surveySessionId: survey.surveySessionId ?? 0, actualEndTime: declinedTime , percentageCompleted : survey.percentageComplete ?? 0 )
                var _ = DatabaseHandler.updateSurveyData(progressStatus: survey.progressStatus ?? "", isDeclined: 1, surveySessionId: survey.surveySessionId ?? 0 , percentageCompleted : survey.percentageComplete ?? 0 )
            }
            if !CheckNetworkUsability.sharedInstance().checkInternetConnection() {
                
                let _ = DatabaseHandler.insertIntoDeclinedSurvey(declinedSurveyArray: declinedSurveyArray)
                var backButtonTitle = "Back to Dashboard"
                if let screen =  kUserDefault.value(forKey: kRootScreen) as? String , screen == AppController.ScheduleController{
                     backButtonTitle = "Back to DRO Schedule"
                }
                let view = CustomErrorAlert.instanceFromNib(title: "Participation Declined!", message: "You're offline. Saving data locally on your device. Data will get synched as soon as you're back online." , okButtonTitle: backButtonTitle, type: .error) as? CustomErrorAlert
                view?.delegate = self
                UIApplication.shared.keyWindow?.addSubview(view!)
            }else{
                CustomActivityIndicator.startAnimating( message: "Declining...")
                
                allDeclineSurveyWebService(declinedSurveyArray){ (success,response , message) in
                    DispatchQueue.main.async {
                        if success {
                            self.getTimeLineData()

                            
                            
                        }else{
                            CustomActivityIndicator.stopAnimating()

                           self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func showDropdown(_ sender: UIButton) {
        chooseDecline.anchorView = sender
        chooseDecline.selectRow(selectedReason)
        // Action triggered on selection
        chooseDecline.selectionAction = { [weak self] (index, item) in
            self?.labelSelectedReason.text = item //.setTitle(item, for: .normal)
            self?.selectedReason = index
        }
        chooseDecline.cellHeight = self.labelSelectedReason.frame.size.height + 16
        chooseDecline.show()
    }
    
   
    func getTimeLineData()  {
        WebServiceMethods.sharedInstance.getTimeline(0, toRow: 200){ (success, response, message) in
            DispatchQueue.main.async {
                CustomActivityIndicator.stopAnimating()
                if success {
                    var timelineArray = [TimelineModel]()
                    for timelineData in response{
                        let timelineModel = TimelineModel(jsonObject: timelineData)
                        timelineArray.append(timelineModel)
                    }
                    let _ = DatabaseHandler.insertIntoTimeline(timelineArray: timelineArray)
                }
                var backButtonTitle = "Back to Dashboard"
                if let screen =  kUserDefault.value(forKey: kRootScreen) as? String , screen == AppController.ScheduleController{
                    backButtonTitle = "Back to DRO Schedule"
                }
                
                let view = CustomErrorAlert.instanceFromNib(title: "Participation Declined!", message: "You have successfully declined to participate . You are now being redirected to Active DROs list", okButtonTitle: backButtonTitle, type: .error) as? CustomErrorAlert
                view?.delegate = self
                UIApplication.shared.keyWindow?.addSubview(view!)
            }
        }
    }
}

//MARK:- UITableViewDataSource

extension DeclineController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.allowsSelection = false
        return surveyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DeclineCell, for: indexPath)  as? DeclineCell
            cell?.labelDroName.text = "\(indexPath.row + 1). " + ( surveyArray[indexPath.row ].name ?? "" )
            cell?.selectionStyle = .none
            return cell!
    }
}

//MARK:- UITableViewDelegate

extension DeclineController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
   
}

//MARK:- CustomErrorAlertDelegate
extension DeclineController: CustomErrorAlertDelegate {
    
    func clickOnOKButton(_ sender:CustomErrorAlert) {
        self.dismiss(animated: true, completion: {
            if  let vc = self.droHome  {
            vc.navigationController?.popToRootViewController(animated: false)
            }else if  let vc = self.questionController  {
                vc.navigationController?.popToRootViewController(animated: false)
            }
        })
    }
}
