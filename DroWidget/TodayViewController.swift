//
//  TodayViewController.swift
//  DroWidget
//
//  Created by Carematix on 04/12/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import NotificationCenter
class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet var noDueLabel: UILabel!
    var titleArray = ["Due Today" , "Upcoming"]
    var upcomingArray = [SurveyScheduleDatabaseModel]()
    var dueTodayArray = [SurveyScheduleDatabaseModel]()
    var maxHeight = CGFloat(0)
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet var upComingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upComingTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
 
        // Do any additional setup after loading the view from its nib.
        updateData()
        var size = self.preferredContentSize
        size.height = maxHeight
        self.preferredContentSize = size
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if (activeDisplayMode == NCWidgetDisplayMode.compact){
            // Changed to compact mode
            var size = maxSize
            size.height = 60
            self.preferredContentSize = size
        }
        else{
            // Changed to expanded mode
            var size = maxSize
            size.height = maxHeight
            self.preferredContentSize = size
        }
//        var size = maxSize
//        size.height = maxHeight
//        self.preferredContentSize = size

    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        updateData()
    
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsets.zero
    }
    
    func updateData() {
        
        var endTime = Int(Date().timeIntervalSince1970)
        endTime  += TimeZone.current.secondsFromGMT()
        let _ = DatabaseHandler.expireOldSuvey(endTime: endTime * 1000)
        let _ = DatabaseHandler.expireOldUnsheduledSuvey(endTime: endTime * 1000)
        let _ = DatabaseHandler.deleteAllUploadedSurvey(endTime: endTime * 1000)
        let _ = DatabaseHandler.enableNewSuvey(startTime :endTime * 1000)
        dueTodayArray.removeAll()
        upcomingArray.removeAll()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: tomorrow)
        if let tomorrowDate = dateFormatter.date(from: dateString) {
            var startTime = Int(tomorrowDate.timeIntervalSince1970)
            startTime  += TimeZone.current.secondsFromGMT()
            upcomingArray = DatabaseHandler.getUpcoming(startTime: startTime * 1000)
            dueTodayArray = DatabaseHandler.getDueToday(startTime: startTime * 1000)
            dueTodayArray += upcomingArray
        }
        upComingTable.reloadData()
        if  dueTodayArray.count > 2 {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }else{
            self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
        }
        if dueTodayArray.count == 0 {
            upComingTable.isHidden = true
            noDueLabel.isHidden = false
        }else{
            upComingTable.isHidden = false
            noDueLabel.isHidden = true
        }
    }
    
}

extension TodayViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // tableView.allowsSelection = false
         // return titleArray.count
        if section == 0 {
            return dueTodayArray.count
        }else{
            return upcomingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowCell") as! RowCell
        cell.textLabel?.numberOfLines = 0
        if indexPath.section == 0 {
            cell.rowTitle.text = dueTodayArray[indexPath.row].surveyName
        }else{
            cell.rowTitle.text = upcomingArray[indexPath.row].surveyName
        }
 
       // gradient.colors = [UIColor(red: 0, green: 168.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor, UIColor.clear.cgColor]
        if let progress = dueTodayArray[indexPath.row].percentageCompleted , Int(progress) != 0 {
            NSLayoutConstraint.deactivate([cell.bottomConstrientToSuperView])

            NSLayoutConstraint.activate([cell.bottomConstrientToProgressView])

            cell.progressView.isHidden = false
            cell.progressView.setProgress(Float(progress / 100), animated: true)

        }else{
            NSLayoutConstraint.deactivate([cell.bottomConstrientToProgressView])

            NSLayoutConstraint.activate([cell.bottomConstrientToSuperView])

            cell.progressView.isHidden = true

            cell.progressView.setProgress(Float(0), animated: true)

        }
        return cell
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.upComingTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    var rect = self.upComingTable.frame
                    rect.origin.y = 0
                    heightConstant.constant = newSize.height
//                    if  newSize.height > 230 {
//                        heightConstant.constant = 230
//                     //  rect.size.height = 230
//                    }else{
//                        heightConstant.constant = newSize.height
//                       // rect.size.height = newSize.height
                 //   }
                    self.maxHeight = heightConstant.constant

                    self.upComingTable.frame = rect
                   // self.upComingTable.scrollsToTop = true
                    
                }
            }
        }
    }

}
extension TodayViewController : UITableViewDelegate{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return titleArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
//        cell.headerTitle.text = titleArray[section]
//        return cell
//
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var survey = SurveyScheduleDatabaseModel()

        if indexPath.section == 0 {
            survey = dueTodayArray[indexPath.row]
        }else{
            survey = upcomingArray[indexPath.row]
        }
        if let sessionId = survey.surveySessionId ,  let url = URL(string: "DroApp://schedule?session=\(sessionId)") , let extensionContext = self.extensionContext {
            extensionContext.open(url, completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugPrint("here")
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.dueTodayArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // share item at indexPath
            debugPrint("I want to share: \(self.dueTodayArray[indexPath.row])")
        }
        
        share.backgroundColor = UIColor.lightGray
        
        return [delete, share]
        
    }

}
