//
//  DroHomeController.swift
//  DROapp
//
//  Created by Carematix on 31/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DroHomeController: UIViewController {

    //MARK:- Outlet
    @IBOutlet var viewContinue: UIView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var droTable: UITableView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var viewDecline: UIView!

    var states : Array<Bool>!
    //MARK:- Variables

    var survey = SurveySubmitModel()
    var imageArray = [#imageLiteral(resourceName: "clockDroHome") , #imageLiteral(resourceName: "wrongAnswer") , #imageLiteral(resourceName: "floppy") , #imageLiteral(resourceName: "automatically")]
    var surveyName = ""
    var reVisit = false
    
    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.setCustomFont()
        continueButton.setCustomFont()
        declineButton.setCustomFont()
        declineButton.layer.cornerRadius = 5.0
        continueButton.layer.cornerRadius = 5.0
        states = [Bool](repeating: true, count: survey.surveyInstructionArray.count + 1)
        if let status = survey.progressStatus , status.lowercased() == "STARTED".lowercased()  {
            viewDecline.isHidden = true
        }else{
            viewDecline.isHidden = false
        }

        if survey.scheduleType == "UNSCHEDULED"{
            viewDecline.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if reVisit{
            viewDecline.isHidden = true
        }
        reVisit = true

    }
    
    //MARK:- Button Action

    @IBAction func declineDro(_ sender: UIButton) {
        let declineController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.DeclineController) as! DeclineController
        declineController.surveyArray = [survey]
        declineController.droHome = self
        self.present(declineController, animated: true, completion: nil)
    }
    
    @IBAction func continueDro(_ sender: UIButton){
        
        let _  = SurveySubmitModel(jsonObject: ["pages" : survey.pagesJson])
        
        let questionnaireController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.QutionnaireController) as! QuestionnaireController
        
        if let startTime = survey.scheduledStartTime , startTime != 0 {
            if let endTime = survey.scheduledEndTime , endTime != 0 {
            }else{
                if let validity = survey.validity , validity != 0 {
                    survey.scheduledEndTime = (validity * 1000 ) + startTime
                }
            }
        }else{
            var startTime = Int(Date().timeIntervalSince1970)
            startTime  += TimeZone.current.secondsFromGMT()
            survey.scheduledStartTime = startTime * 1000
            if let validity = survey.validity , validity != 0 {
                survey.scheduledEndTime = ( startTime + validity ) * 1000
            }
        }
        
        questionnaireController.survey = survey
        self.navigationController?.pushViewController(questionnaireController, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- UITableViewDataSource

extension DroHomeController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return survey.surveyInstructionArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DroDetailCell, for: indexPath)  as? DroDetailCell
            cell?.selectionStyle = .none
            cell?.labelQuestionaireDescription.text = survey.surveyIntroductionText
            cell?.labelQuestionnaireName.text = survey.name
            
            if let programName = survey.programName  {
                cell?.labelQuestionnaireType.text  = (survey.organizationName ?? "") + " : " + programName
            }
            if let endTime = survey.scheduledEndTime , endTime != 0 {
                let localDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000) )
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let dateString = dateFormatter.string(from: localDate)
                cell?.labelDueDate.text =  dateString
            }else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let dateString = dateFormatter.string(from: Date())
                cell?.labelDueDate.text =  dateString
            }
            var dueString = "Due by"
            if let dashboard = kUserDefault.value(forKey: kdashboard) as? [String : Any] {
                if let due = dashboard["26"] as? String {
                    dueString = due
                }
            }
            cell?.labelDueBy.text = dueString
            
            cell?.labelEstimated.text = "Est. time required"
            cell?.labelEstimatedTime.text = "10 Minutes"
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.InsturctionDetailCell, for: indexPath)  as? InsturctionDetailCell
            cell?.imgInstruction.image = #imageLiteral(resourceName: "clockDroHome")
            if survey.surveyInstructionArray[indexPath.row - 1].type == "TIMING"{
                cell?.imgInstruction.image = #imageLiteral(resourceName: "clockDroHome")
            }else if survey.surveyInstructionArray[indexPath.row - 1].type == "AUTOSAVE_TRUE"{
                cell?.imgInstruction.image = #imageLiteral(resourceName: "floppy")
            }else if survey.surveyInstructionArray[indexPath.row - 1].type == "WRONG_ANSWER"{
                cell?.imgInstruction.image = #imageLiteral(resourceName: "wrongAnswer")
            }else if survey.surveyInstructionArray[indexPath.row - 1].type == "GOBACK_TRUE"{
                cell?.imgInstruction.image = #imageLiteral(resourceName: "automatically")
            }
        
            cell?.labelInstruction.delegate = self
            cell?.labelInstruction.setLessLinkWith(lessLink: "Hide", attributes: [.foregroundColor:UIColor.appButtonColor , .font: (cell?.labelInstruction.font)! ], position: .left)
            
            cell?.layoutIfNeeded()
            
            cell?.labelInstruction.shouldCollapse = true
            cell?.labelInstruction.textReplacementType = .word
            cell?.labelInstruction.numberOfLines = 4
            cell?.labelInstruction.collapsed = states[indexPath.row]
            cell?.labelInstruction.text = survey.surveyInstructionArray[indexPath.row - 1].descriptions
            cell?.selectionStyle = .none
            return cell!
        }
    }
}

//MARK:- UITableViewDelegate

extension DroHomeController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK:- ExpandableLabelDelegate

extension DroHomeController : ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        droTable.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: droTable)
        if let indexPath = droTable.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.droTable.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        droTable.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        droTable.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: droTable)
        if let indexPath = droTable.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.droTable.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        droTable.endUpdates()
    }
}

