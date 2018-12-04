//
//  DashboardStatisticsCell.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import FoldingCell
class DashboardStatisticsCell: FoldingCell {
    @IBOutlet var imgHalf: UIImageView!
    
    @IBOutlet var labelCompliance: UILabel!
    @IBOutlet var labelComplianeNumber: UILabel!
    @IBOutlet var imgCompliance: UIImageView!
    @IBOutlet var labelDeclined: UILabel!
    @IBOutlet var labelDeclinedNumber: UILabel!
    @IBOutlet var imgDeclined: UIImageView!
    @IBOutlet var labelExpired: UILabel!
    @IBOutlet var labelExpiredNumber: UILabel!
    @IBOutlet var imgExpired: UIImageView!
    @IBOutlet var labelActivated: UILabel!
    @IBOutlet var labelActivatedNumber: UILabel!
    @IBOutlet var imgActivated: UIImageView!
    @IBOutlet var labelCompleted: UILabel!
    @IBOutlet var labelCompletedNumber: UILabel!
    @IBOutlet var imgCompleted: UIImageView!
    @IBOutlet var labelAssigned: UILabel!
    @IBOutlet var labelAssignedNumber: UILabel!
    @IBOutlet var imgAssigned: UIImageView!
    @IBOutlet var bottomConstrient: NSLayoutConstraint!
    @IBOutlet weak var labelDueToday: UILabel!
    
    @IBOutlet var labelStatistics: UILabel!
    @IBOutlet weak var upperView: RotatedView!
    
    @IBOutlet weak var batchNumber: UILabel!
    
    @IBOutlet weak var buttonCollapse: UIButton!
    
    @IBOutlet var buttonClose: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        batchNumber.setCustomFont()
        labelDueToday.setCustomFont()
        labelStatistics.setCustomFont()
        labelAssigned.setCustomFont()
        labelAssignedNumber.setCustomFont()
        labelCompleted.setCustomFont()
        labelCompletedNumber.setCustomFont()
        labelActivated.setCustomFont()
        labelActivatedNumber.setCustomFont()
        labelExpired.setCustomFont()
        labelExpiredNumber.setCustomFont()
        labelDeclined.setCustomFont()
        labelDeclinedNumber.setCustomFont()
        labelComplianeNumber.setCustomFont()
        labelCompliance.setCustomFont()
        DispatchQueue.main.async {
            self.batchNumber.layer.cornerRadius = self.batchNumber.frame.size.width / 2
        }
        foregroundView.layer.borderWidth = 1
        foregroundView.layer.borderColor = UIColor(red: 0.9137, green: 0.9373, blue: 0.9490, alpha: 1.0).cgColor
        batchNumber.clipsToBounds = true
        self.backViewColor = .white

        if UIDevice.current.userInterfaceIdiom == .pad{
            containerView.layer.cornerRadius = 15.0
            upperView.layer.cornerRadius = 15.0
            
        }else{
            containerView.layer.cornerRadius = 7.0
            upperView.layer.cornerRadius = 7.0
        }
        self.containerView.clipsToBounds = true
        self.upperView.clipsToBounds = true
        self.foregroundView.clipsToBounds = true

        foregroundView.layer.masksToBounds = true

        upperView.layer.masksToBounds = true
        self.itemCount = 4
        NSLayoutConstraint.deactivate([bottomConstrient])
        setText()
    }
    
    func setText() {
        self.itemCount = 4
        labelActivated.text = "Active"
        var newCompleteCount = DatabaseHandler.getCompleteSurveyCount()
        if let oldCompleteCount = kUserDefault.value(forKey: kOldCompleteCount) as? Int {
            newCompleteCount = newCompleteCount - oldCompleteCount
        }
        
        var newExpiredCount = DatabaseHandler.getExpiredSurveyCount()
        if let oldExpiredCount = kUserDefault.value(forKey: kOldExpiredCount) as? Int {
            newExpiredCount = newExpiredCount - oldExpiredCount
        }
        var newDeclineCount = DatabaseHandler.getDeclinedSurveyCount()
        if let oldCompleteCount = kUserDefault.value(forKey: kOldDeclineCount) as? Int {
            newDeclineCount = newDeclineCount - oldCompleteCount
        }
        
        var newAssignCount = DatabaseHandler.getAssignSurveyCount()
        if let newCompleteCount = kUserDefault.value(forKey: kOldAssignCount) as? Int {
            newAssignCount = newAssignCount - newCompleteCount
        }
        
        let activeCount = DatabaseHandler.getActiveSurveyCount()
        if let assigned = kUserDefault.value(forKey: kassigned) as? Int {
            labelAssignedNumber.text = "\(assigned + newAssignCount)"
        }else{
            labelAssignedNumber.text = "\(newAssignCount)"
            
        }
        if let completed = kUserDefault.value(forKey: kcompleted) as? Int {
            labelCompletedNumber.text = "\(completed + newCompleteCount)"
        }else{
            labelCompletedNumber.text = "\( newCompleteCount)"
        }
        labelActivatedNumber.text = "\(activeCount)"

        if let declined = kUserDefault.value(forKey: kdeclined) as? Int {
            labelDeclinedNumber.text = "\(declined + newDeclineCount)"
        }else{
            labelDeclinedNumber.text = "\(newDeclineCount)"
            
        }
        if let expired = kUserDefault.value(forKey: kexpired) as? Int {
            labelExpiredNumber.text = "\(expired + newExpiredCount)"
        }else{
            labelExpiredNumber.text = "\(newExpiredCount)"
        }
        
        if let assigned = kUserDefault.value(forKey: kassigned) as? Int , let completed = kUserDefault.value(forKey: kcompleted) as? Int{
            if completed == 0 {
                labelComplianeNumber.text = "0%"

            }else{
                labelComplianeNumber.text =  String(format: "%0.1f ", ( Float(completed + newCompleteCount) / Float(assigned + newAssignCount)) * 100 ) + "%"

            }
        }else{
            labelComplianeNumber.text =  String(format: "%0.1f ", ( Float(newCompleteCount) / Float( newAssignCount)) * 100 ) + "%"
        }
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        var durations = [kExpandDuration, kExpandDuration]
        for _ in  0..<(itemCount) {
            durations.append(kExpandDuration)
        }
        return durations[itemIndex]
    }
    
    @IBAction func expandCell(_ sender: UIButton) {
        let dict = [kOpen : Collapse.open , kCell : DashboardCellType.Statistics] as [String : Any]
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }
 
    @IBAction func collapseCell(_ sender: UIButton) {
        let dict = [kOpen : Collapse.close , kCell : DashboardCellType.Statistics] as [String : Any]
         NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }
    
}
