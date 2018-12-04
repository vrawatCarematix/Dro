//
//  UpcomingRowCell.swift
//  DROapp
//
//  Created by Carematix on 09/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class UpcomingRowCell: UITableViewCell {

    //MARK:- Outlets
   // var userSession = UserSurveySessionModel()
    
    
    @IBOutlet var progressView: UICircularProgressRingView!
    @IBOutlet var buttonStart: UIButton!
    @IBOutlet var labelType: UILabel!
    @IBOutlet var labelDue: UILabel!
    @IBOutlet var labelTitle: UILabel!
    
    //MARK:- Variables
    var upcoming = SurveyScheduleDatabaseModel()
    var label = UILabel()
    var isLableAddeded = false
    
    //MARK:- View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.setCustomFont()
        labelType.setCustomFont()
        labelDue.setCustomFont()
        buttonStart.setCustomFont()
       
        if UIDevice.current.userInterfaceIdiom == .pad {
            progressView.outerRingWidth = 4
            progressView.innerRingWidth = 4
        }else{
            progressView.outerRingWidth = 2
            progressView.innerRingWidth = 2
        }
        progressView.startAngle = 270
        progressView.ringStyle = .ontop
        progressView.value = 0
        progressView.font = labelType.font
       // progressView.showFloatingPoint = true
        //progressView.decimalPlaces = 1
        progressView.ringStyle = .ontop
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "No Upcoming DROs"
        label.font = labelTitle.font
        label.isHidden = true
        if !isLableAddeded {
            DispatchQueue.main.async {
                self.label.frame = self.bounds
            }
            self.contentView.addSubview(label)
            isLableAddeded = true
        }
        // Initialization code
    }
    func showAlert() {
        self.contentView.bringSubviewToFront(label)
        label.frame = self.bounds
        label.isHidden = false
    }
    
    func setText() {
        label.isHidden = true
        if let progrss = upcoming.percentageCompleted  {
            progressView.value = CGFloat(progrss)
        }else{
            progressView.value = 0
        }
        if let surveyName = upcoming.surveyName{
            labelTitle.text = surveyName
        }else{
            labelTitle.text = ""
        }
        if let programName = kUserDefault.value(forKey: kprogramName) as? String{
            labelType.text = programName
        }else{
            labelType.text = ""
        }
        
        if let endTime = upcoming.endTime , endTime != 0 {
            let endDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000))
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            var dueString = "Due by"
            if let dashboard = kUserDefault.value(forKey: kdashboard) as? [String : Any] {
                if let due = dashboard["26"] as? String {
                    dueString = due
                }
            }
            labelDue.text = dueString + " " + dateFormatter.string(from: endDate)
        }else{
            labelDue.text = ""
        }
        if let progressStatus = upcoming.progressStatus , progressStatus == "NOT_STARTED"  {
            progressView.isHidden = true
            buttonStart.setTitle("Start", for: .normal)
        }else{
            progressView.isHidden = false
            buttonStart.setTitle("Continue", for: .normal)
        }
//        if let scheduleType = upcoming.s , scheduleType == "SCHEDULED"  {
//            if let progressStatus = upcoming.progressStatus , progressStatus == "NOT_STARTED"  {
//                progressView.isHidden = true
//                buttonStart.setTitle("Start", for: .normal)
//            }else{
//                progressView.isHidden = false
//                buttonStart.setTitle("Continue", for: .normal)
//            }
//        }else{
//            progressView.isHidden = true
//        }
        
        
        
//        if let progrss = userSession.surveySessionInfo.percentageCompleted  {
//            progressView.value = CGFloat(progrss)
//        }else{
//            progressView.value = 0
//
//        }
//        if let surveyName = userSession.surveyName{
//            labelTitle.text = surveyName
//        }else{
//            labelTitle.text = ""
//
//        }
//        if let programName = kUserDefault.value(forKey: kprogramName) as? String{
//            labelType.text = programName
//        }else{
//            labelType.text = ""
//
//        }
//
//        if let endTime = userSession.surveySessionInfo.endTime  {
//            let endDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000))
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM dd, yyyy"
//            var dueString = "Due by"
//
//            if let dashboard = kUserDefault.value(forKey: kdashboard) as? [String : Any] {
//                if let due = dashboard["26"] as? String {
//                    dueString = due
//                }
//            }
//            labelDue.text = dueString + " " + dateFormatter.string(from: endDate)
//        }else{
//            labelDue.text = ""
//
//        }
//        if let scheduleType = userSession.surveySessionInfo.scheduleType , scheduleType == "SCHEDULED"  {
//            if let progressStatus = userSession.surveySessionInfo.progressStatus , progressStatus == "NOT_STARTED"  {
//                progressView.isHidden = true
//                buttonStart.setTitle("Start", for: .normal)
//            }else{
//                progressView.isHidden = false
//                buttonStart.setTitle("Continue", for: .normal)
//            }
//        }else{
//            progressView.isHidden = true
//        }
    }

}
