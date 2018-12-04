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
    
    var titleArray = ["Due Today" , "Upcoming"]
    var upcomingArray = [SurveyScheduleDatabaseModel]()
    var dueTodayArray = [SurveyScheduleDatabaseModel]()
    @IBOutlet var upComingTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        updateData()


    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        if (activeDisplayMode == NCWidgetDisplayMode.compact){
            // Changed to compact mode
            self.preferredContentSize = maxSize
        }
        else{
            // Changed to expanded mode
            self.preferredContentSize = maxSize
        }

    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        updateData()
    
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
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
        }
        upComingTable.reloadData()
    }
    
}

extension TodayViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.allowsSelection = false
          return titleArray.count
//        if section == 0 {
//            return dueTodayArray.count
//        }else{
//            return upcomingArray.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        //        if indexPath.section == 0 {
//            cell?.textLabel?.text = dueTodayArray[indexPath.row].surveyName
//        }else{
//            cell?.textLabel?.text = upcomingArray[indexPath.row].surveyName
//        }
        
       cell?.textLabel?.text =  titleArray[indexPath.row]
        return cell!
    }
    

}
extension TodayViewController : UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleArray[section]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("s")
    }
}
