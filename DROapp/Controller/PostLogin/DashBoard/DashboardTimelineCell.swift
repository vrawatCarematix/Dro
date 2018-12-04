//
//  DashboardTimelineCell.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import FoldingCell
class DashboardTimelineCell: FoldingCell {
    
    //MARK:- Outlets
    @IBOutlet var bottomConstrient: NSLayoutConstraint!
    @IBOutlet var cardView: CardView!
    @IBOutlet var imgHalf: UIImageView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var labelDueToday: UILabel!
    @IBOutlet weak var upperView: RotatedView!
    @IBOutlet weak var batchNumber: UILabel!
    @IBOutlet weak var buttonCollapse: UIButton!
    @IBOutlet weak var expendTable: UITableView!
    @IBOutlet var buttonClose: UIButton!
    @IBOutlet var labelStatistics: UILabel!
    @IBOutlet var buttonOpen: UIButton!
    
    //MARK:- Variables

    var timelineArray = [TimelineModel]()
    var cardviewHeight = CGFloat(0)
    var maximumHeight = CGFloat(0)
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getTimeLineData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        batchNumber.setCustomFont()
        labelDueToday.setCustomFont()
        labelStatistics.setCustomFont()
        DispatchQueue.main.async {
            self.batchNumber.layer.cornerRadius = self.batchNumber.frame.size.width / 2
            self.cardviewHeight = self.cardView.frame.size.height + 28
            self.expendTable.reloadData()
        }
        self.expendTable.addSubview(self.refreshControl)
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.attributedTitle =  NSAttributedString(string: "Refreshing...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ,NSAttributedString.Key.font: UIFont(name: kSFSemibold, size:labelStatistics.font.pointSize)!])
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
        self.backViewColor = .white

        self.containerView.clipsToBounds = true
        expendTable.dataSource = self
        expendTable.delegate = self
        self.expendTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        upperView.layer.masksToBounds = true
        self.timelineArray = DatabaseHandler.getAllTimeline()
        self.expendTable.reloadData()
        if self.timelineArray.count > 5 {
            self.itemCount = 7
        }else{
            self.itemCount = self.timelineArray.count + 2
        }
        NSLayoutConstraint.deactivate([bottomConstrient])
        // Initialization code
    }
    
    func configCell(array : [TimelineModel])   {
        self.timelineArray = DatabaseHandler.getAllTimeline()
        self.expendTable.reloadData()
        if self.timelineArray.count > 5 {
            self.itemCount = 7
        }else{
            self.itemCount = self.timelineArray.count + 2
        }
        NSLayoutConstraint.deactivate([bottomConstrient])
    }
    
    func getTimeLineData()  {
       // CustomActivityIndicator.startAnimating( message: "Loading...")
        WebServiceMethods.sharedInstance.getTimeline(0, toRow: 2000){ (success, response, message) in
            DispatchQueue.main.async {
            //    CustomActivityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                if success {
                    self.timelineArray.removeAll()
                    for timelineData in response{
                        let timelineModel = TimelineModel(jsonObject: timelineData)
                        self.timelineArray.append(timelineModel)
                    }
                    if self.timelineArray.count > 5 {
                        self.itemCount = 7
                    }else{
                        self.itemCount = self.timelineArray.count + 2
                    }
                    let _ = DatabaseHandler.insertIntoTimeline(timelineArray: self.timelineArray)
                }
                self.expendTable.reloadData()
            }
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.expendTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    var rect = self.expendTable.frame
                    rect.origin.y = cardviewHeight
                    heightConstant.constant = newSize.height
                    if (maximumHeight - cardviewHeight  ) > 10 && newSize.height > ( maximumHeight - cardviewHeight ) {
                        heightConstant.constant = maximumHeight - cardviewHeight
                        rect.size.height = maximumHeight - cardviewHeight
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
    
    @IBAction func expandCell(_ sender: UIButton) {
        let dict = [kOpen : Collapse.open , kCell : DashboardCellType.Timeline] as [String : Any]
         NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }
    
    @IBAction func collapseCell(_ sender: UIButton) {
        let dict = [kOpen : Collapse.close , kCell : DashboardCellType.Timeline] as [String : Any]
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }
    
   
}

extension DashboardTimelineCell : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if timelineArray.count > 7 {
//            return 7
//        }else{
            return timelineArray.count
       // }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineArray[section].eventArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TimelineRowCell, for: indexPath) as? TimelineRowCell
        
        if indexPath.section == ( timelineArray.count - 1 ) {
            cell?.imgTimeline.isHidden = true
        }else{
            cell?.imgTimeline.isHidden = false
        }
        let event =  timelineArray[indexPath.section].eventArray[indexPath.row]
        cell?.labelDetail.text = event.msg
        if event.event == kEXPIRED {
            cell?.imgDetail.image = #imageLiteral(resourceName: "expired")
        }else if event.event == kCOMPLETED{
            cell?.imgDetail.image = #imageLiteral(resourceName: "completedDash")
        }else if event.event == kASSIGNED{
            cell?.imgDetail.image = #imageLiteral(resourceName: "assigned")
            
        }else if event.event == kDECLINED || event.event?.lowercased() == "decline" {
            cell?.imgDetail.image = #imageLiteral(resourceName: "declined")
            
        }else{
            cell?.imgDetail.image = #imageLiteral(resourceName: "activated")
        }
        
        return cell!
    }
}

extension DashboardTimelineCell : UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TimelineHeaderCell) as? TimelineHeaderCell
        if section == 0 {
            cell?.imgUpper.isHidden = true
        }else{
            cell?.imgUpper.isHidden = false
        }
        if section == timelineArray.count - 1 {
            cell?.imgLower.isHidden = true
            
        }else{
            cell?.imgLower.isHidden = false
        }
        let timeline =  timelineArray[section]
        let date = Date(timeIntervalSince1970: TimeInterval((timeline.date ?? 0) / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        cell?.timelineDateNumber.text = dateFormatter.string(from: date)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd MM yy"
        
        let dateString = dateFormatter2.string(from: Date())
        let todayDate = dateFormatter2.date(from: dateString)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: todayDate!)!
        if date < yesterday {
            let dateFormatter3 = DateFormatter()

            dateFormatter3.dateFormat = "EEEE,  MMMM yyyy"
             cell?.timelineDate.text = dateFormatter3.string(from: date)

        }else{
            let dateFormatter3 = DateFormatter()
            dateFormatter3.dateStyle = .full
            dateFormatter3.doesRelativeDateFormatting = true
            cell?.timelineDate.text = dateFormatter3.string(from: date)
        }
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
    
}
