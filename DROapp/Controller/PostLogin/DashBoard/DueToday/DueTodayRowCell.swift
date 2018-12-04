//
//  DueTodayRowCell.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import FoldingCell

class DueTodayRowCell: UITableViewCell {

    //MARK:- Outlets

    @IBOutlet var labelType: UILabel!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet weak var statusView: UICircularProgressRingView!
    
    //MARK:- Variables
    var dueToday = SurveyScheduleDatabaseModel()
    var label = UILabel()
    var isLableAddeded = false
    
    //MARK:- View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        labelType.setCustomFont()
        labelTitle.setCustomFont()
        if UIDevice.current.userInterfaceIdiom == .pad {
            statusView.outerRingWidth = 4
            statusView.innerRingWidth = 4
        }else{
            statusView.outerRingWidth = 2
            statusView.innerRingWidth = 2
        }
        //statusView.showFloatingPoint = true
        //statusView.decimalPlaces = 1
        statusView.startAngle = 270
        statusView.ringStyle = .ontop
        statusView.value = 0
        statusView.font = labelType.font
        statusView.ringStyle = .ontop
        labelTitle.numberOfLines = 0
        labelType.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "No Due Today DROs"
        label.font = labelTitle.font
        label.isHidden = true
        if !isLableAddeded {
            DispatchQueue.main.async {
                self.label.frame = self.bounds

            }
            self.contentView.addSubview(label)
            isLableAddeded = true
            
        }
    }

    func showAlert() {
        self.contentView.bringSubviewToFront(label)
        label.frame = self.bounds
        label.isHidden = false
    }
    
    func setText() {
        label.isHidden = true

        if let progrss = dueToday.percentageCompleted  {
            statusView.value = CGFloat(progrss)
        }else{
            statusView.value = 0
        }
        if let surveyName = dueToday.surveyName{
            labelTitle.text = surveyName
        }else{
            labelTitle.text = ""
        }
        if let programName = kUserDefault.value(forKey: kprogramName) as? String{
            labelType.text = programName
        }else{
            labelType.text = ""
        }
        
//        if let endTime = dueToday.endTime  {
//            let endDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000))
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM dd, yyyy"
//            var dueString = "Due by"
//            if let dashboard = kUserDefault.value(forKey: kdashboard) as? [String : Any] {
//                if let due = dashboard["26"] as? String {
//                    dueString = due
//                }
//            }
//            label.text = dueString + " " + dateFormatter.string(from: endDate)
//        }else{
//            labelDue.text = ""
//        }
//        if let progressStatus = dueToday.progressStatus , progressStatus == "NOT_STARTED"  {
//            progressView.isHidden = true
//            buttonStart.setTitle("Start", for: .normal)
//        }else{
//            progressView.isHidden = false
//            buttonStart.setTitle("Continue", for: .normal)
//        }

    }


}
