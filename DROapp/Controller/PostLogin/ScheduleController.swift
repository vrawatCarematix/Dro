//
//  ScheduleController.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit


//MARK:- Calender Theme
enum MyTheme {
    case light
    case dark
}

class ScheduleController :  UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var scheduleTable: UITableView!
    @IBOutlet var navView :  UIView!
    @IBOutlet var labelTitle: UILabel!
    var headerCell = ScheduleHeaderCell()
    
    //MARK:- Variables

    var survey = [String : Any]()
    var selectedDate = Date()
    lazy var  calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.light)
        calenderView.translatesAutoresizingMaskIntoConstraints=false
        return calenderView
    }()
    var calenderSessionArray = [CalanderModel]()
    var selectedMonthSessionArray = [SurveyScheduleDatabaseModel]()
    var selectedDateSessionArray = [SurveyScheduleDatabaseModel]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            getCalenderData()
        }else{
            self.refreshControl.endRefreshing()
        }
    }
    
    
    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.setCustomFont()
        calenderView.delegate = self
        calenderView.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: Date())
        selectedDate = dateFormatter.date(from: dateString)!
        scheduleTable.allowsSelection = false
        //Pull to refesh
        self.scheduleTable.addSubview(self.refreshControl)
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.attributedTitle =  NSAttributedString(string: kRefreshing.localisedString().capitalized + "..." , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ,NSAttributedString.Key.font: UIFont(name: kSFSemibold, size:labelTitle.font.pointSize - 2 )!])
        
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
           // getCalenderData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)
    }
    
    //MARK:- Changes Text on language Changes
    @objc func setText()  {
        var endTime = Int(Date().timeIntervalSince1970)
        endTime  += TimeZone.current.secondsFromGMT()
        let _ = DatabaseHandler.expireOldSuvey(endTime: endTime * 1000)
        let _ = DatabaseHandler.enableNewSuvey(startTime: endTime * 1000)
        labelTitle.text = kSchedule_DRO.localisedString().capitalized
        self.showSelectedDataData(date: self.selectedDate)
        showDataOnCalender()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kUserDefault.set(AppController.ScheduleController, forKey: kRootScreen)
        setText()
    }
    
    override func viewWillDisappear(_ animated :  Bool) {
        self.tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    //MARK:- Fatch Calender Data

    func getCalenderData() {
        let currentMonth = calenderView.currentMonthIndex
        let currentYear = calenderView.currentYear
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let newDate = formatter.date(from: "\(currentYear)" + "-" +  "\(currentMonth)" + "-01")
        let toDate = Calendar.current.date(byAdding: .month, value: 1, to: newDate!)
        let fromepoch = (newDate?.timeIntervalSince1970)! * 1000
        let toepoch = ((toDate?.timeIntervalSince1970)! - 1) * 1000
        CustomActivityIndicator.startAnimating( message: kLoading.localisedString() + "...")
        WebServiceMethods.sharedInstance.getScheduleCalender(Int(fromepoch), toDate: Int(toepoch)) { (success, response, message) in
         //   debugPrint("getScheduleCalender ------>" + response.description)
            DispatchQueue.main.async {
                CustomActivityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()

                if success {
                    self.calenderSessionArray.removeAll()
                    for calenderSessionData in response{
                       let calenderSession = CalanderModel(jsonObject: calenderSessionData)
                        self.calenderSessionArray.append(calenderSession)
                    }
                    var surveyDatabaseModel = [SurveyScheduleDatabaseModel]()
                    for calenderSession in self.calenderSessionArray{
                        for session in calenderSession.sessionsArray {
                          let surveyDatabase = SurveyScheduleDatabaseModel()
                            surveyDatabase.surveyDate = calenderSession.date
                            surveyDatabase.sessionCount = calenderSession.sessionCount
                            surveyDatabase.startTime = session.startTime
                            surveyDatabase.endTime = session.endTime
                            surveyDatabase.surveyID = session.survey.id
                            surveyDatabase.programSurveyId = session.survey.programSurveyId
                            surveyDatabase.isPriority = session.survey.isPriority
                            surveyDatabase.surveyName = session.survey.name
                            surveyDatabase.surveySessionId = session.id
                            surveyDatabase.percentageCompleted = session.userSession.percentageCompleted
                            surveyDatabase.progressStatus = session.userSession.progressStatus
                            surveyDatabase.timeSpent = session.userSession.timeSpent
                            surveyDatabase.isDeclined = session.userSession.isDeclined
                            surveyDatabase.scheduleType = session.scheduleType ?? "SCHEDULED"
                            if let actualendTme = session.userSession.endTime , actualendTme != 0 {
                                surveyDatabase.actualEndTime = actualendTme
                            }else{
                                surveyDatabase.actualEndTime = session.endTime
                            }
                            surveyDatabaseModel.append(surveyDatabase)
                        }
                    }
                   let _ = DatabaseHandler.insertIntoSurveySchedules(surveySchedulesArray: surveyDatabaseModel)
                    self.showDataOnCalender()
                }
                else{
                    self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                    self.showDataOnCalender()

                }
            }
        }
    }
    
    func showDataOnCalender(){
        selectedMonthSessionArray.removeAll()
        let currentMonth = calenderView.currentMonthIndex
        let currentYear = calenderView.currentYear
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation:"UTC")
        let newDate = formatter.date(from: "\(currentYear)" + "-" +  "\(currentMonth)" + "-01")
        let toDate = Calendar.current.date(byAdding: .month, value: 1, to: newDate!)
        let fromEpoch = (newDate?.timeIntervalSince1970)! * 1000
        let toEpoch = ((toDate?.timeIntervalSince1970)! - 1) * 1000
        
        selectedMonthSessionArray = DatabaseHandler.getAllSurveySchedules(startTime: Int(fromEpoch), endTime: Int(toEpoch))
        let dateArray = self.selectedMonthSessionArray.compactMap({ $0.surveyDate})
        self.calenderView.bookedSlotDate.removeAll()
        self.calenderView.bookedSlotDate = dateArray
        self.calenderView.myCollectionView.reloadData()
        if self.selectedDate != Date(){
            self.showSelectedDataData(date: self.selectedDate)
        }
    }

    //MARK:- Button Action

    @IBAction func showDate(_ sender :  UIButton) {
        if calenderView.isHidden {
            view.addSubview(calenderView)
            calenderView.delegate = self
            calenderView.topAnchor.constraint(equalTo : self.navView.bottomAnchor).isActive = true
            calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive=true
            calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive=true
            let screen = UIScreen.main.bounds
            if UIDevice.current.userInterfaceIdiom == .pad{
                calenderView.heightAnchor.constraint(equalToConstant: ((screen.width / 7) * 5) + 130 ).isActive=true
            }else{
                calenderView.heightAnchor.constraint(equalToConstant: ((screen.width / 7) * 6) + 65 ).isActive=true
            }
        }
        calenderView.isHidden = !calenderView.isHidden
    }
    
    @objc func dismissVC(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSelectedDataData(date :Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yy"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: date)
        let utcDate = dateFormatter.date(from: dateString)
        let epoch = (utcDate?.timeIntervalSince1970)! * 1000
        selectedDateSessionArray.removeAll()
        selectedDateSessionArray = selectedMonthSessionArray.filter({ ($0.surveyDate ?? 0) == Int(epoch)})
        scheduleTable.reloadData()
    }
    
    @objc func getSurvey( sender :UIButton) {
        let session = selectedDateSessionArray[sender.tag]
        
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
//            if let status = survey.progressStatus , status.lowercased() == "STARTED".lowercased()  {
//                let questionnaireController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.QutionnaireController) as! QuestionnaireController
//                questionnaireController.survey = survey
//                self.navigationController?.pushViewController(questionnaireController, animated: true)
//            }else{
                let droHomeController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.DroHomeController) as! DroHomeController
                droHomeController.survey = survey
                self.navigationController?.pushViewController(droHomeController ,  animated :  true)
           // }
        }
    }
}

//MARK:- UITableViewDataSource

extension ScheduleController  :  UITableViewDataSource{
    
    func tableView(_ tableView :  UITableView ,  numberOfRowsInSection section :  Int) -> Int {
        return selectedDateSessionArray.count
    }
    
    func tableView(_ tableView :  UITableView ,  cellForRowAt indexPath :  IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier :  ReusableIdentifier.ScheduleRowCell) as? ScheduleRowCell
        let session = selectedDateSessionArray[indexPath.row]
        cell?.labelTitle.text = session.surveyName
        
        if let endTime = session.endTime {
            let localDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000) )
            let dateFormatter = DateFormatter()
            if let selectedLanguageCode = kUserDefault.value(forKey: kselectedLanguage) as? String {
                dateFormatter.locale = Locale(identifier: selectedLanguageCode)
            }else{
                dateFormatter.locale = Locale(identifier: "EN")
            }
            dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
            let dateString = dateFormatter.string(from: localDate)
            cell?.labelDue.text = kDue_by.localisedString() + " " + dateString
        }else{
            cell?.labelDue.text = " "
        }
        if let programName = kUserDefault.value(forKey: kprogramName) as? String {
            cell?.labelType.text = programName
        }else{
            cell?.labelType.text = ""
        }
        cell?.progrssStatusView.isHidden = false
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell?.startButtonTopConstant.constant = 18
            cell?.startButtonBottomConstant.constant = 18
        }else{
            cell?.startButtonTopConstant.constant = 6
            cell?.startButtonBottomConstant.constant = 6
        }
        if let startTime = session.startTime {
            let localtime = Int(Date().timeIntervalSince1970) * 1000
            if startTime > localtime {
                session.progressStatus = nil
                if let endTime = session.startTime {
                    let localDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000) )
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"
                    let dateString = dateFormatter.string(from: localDate)
                    cell?.labelDue.text = kStarts_at.localisedString() + " " + dateString
                }else{
                    cell?.labelDue.text = " "
                }
                cell?.buttonStart.setTitle("", for: .normal)
                cell?.startButtonTopConstant.constant = 0
                cell?.startButtonBottomConstant.constant = 0
            }
        }
        if let isDeclined = session.isDeclined , isDeclined == 1 {
            cell?.buttonStart.setTitle(kDeclined.localisedString().capitalized, for: .normal)
            cell?.progressView.isHidden = true
            cell?.buttonStart.isUserInteractionEnabled = false
        }else{
            if let progressStatus = session.progressStatus {
                if progressStatus.lowercased() == "NOT_STARTED".lowercased()  {
                    cell?.progressView.isHidden = true
                    cell?.buttonStart.setTitle(kStart.localisedString().capitalized, for: .normal)
                    cell?.buttonStart.isUserInteractionEnabled = true
                    cell?.buttonStart.tag = indexPath.row
                    cell?.buttonStart.addTarget(self, action: #selector(getSurvey), for: .touchUpInside)
                }else if progressStatus.lowercased() == "Continue".lowercased() || progressStatus.lowercased() == "STARTED".lowercased() {
                    if let percentageCompleted = session.percentageCompleted {
                        cell?.progressView.value = CGFloat(percentageCompleted)
                    }
                    cell?.buttonStart.isUserInteractionEnabled = true
                    cell?.buttonStart.tag = indexPath.row
                    cell?.progressView.isHidden = false
                    cell?.buttonStart.setTitle(kContinue.localisedString().capitalized, for: .normal)
                    cell?.buttonStart.addTarget(self, action: #selector(getSurvey), for: .touchUpInside)
                }else{
                    cell?.buttonStart.setTitle(progressStatus.capitalized.localisedString(), for: .normal)
                    cell?.progressView.isHidden = true
                    cell?.buttonStart.isUserInteractionEnabled = false
                }
            }else{
                cell?.buttonStart.setTitle("", for: .normal)
                cell?.progressView.isHidden = true
                cell?.buttonStart.isUserInteractionEnabled = false
                cell?.progrssStatusView.isHidden = true
                cell?.startButtonTopConstant.constant = 0
                cell?.startButtonBottomConstant.constant = 0
            }
        }
        cell?.contentView.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell!
    }
}

//MARK:- UITableViewDelegate

extension ScheduleController  :  UITableViewDelegate{
    
    func tableView(_ tableView :  UITableView ,  heightForRowAt indexPath :  IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView :  UITableView ,  estimatedHeightForRowAt indexPath :  IndexPath) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView :  UITableView ,  viewForHeaderInSection section :  Int) -> UIView? {
        headerCell = (tableView.dequeueReusableCell(withIdentifier :  ReusableIdentifier.ScheduleHeaderCell) as? ScheduleHeaderCell)!
        let dateFormatter = DateFormatter()
        if let selectedLanguageCode = kUserDefault.value(forKey: kselectedLanguage) as? String {
            dateFormatter.locale = Locale(identifier: selectedLanguageCode)
        }else{
            dateFormatter.locale = Locale(identifier: "EN")
        }
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateDateAndTimeString = dateFormatter.string(from: selectedDate)
        headerCell.labelDro.text = kDRO_Scheduled_Today.localisedString().replacingOccurrences(of: "kCOUNT", with: "\(selectedDateSessionArray.count)").replacingOccurrences(of: "kDATE", with: dateDateAndTimeString)
        return headerCell
    }
    func tableView(_ tableView :  UITableView ,  heightForHeaderInSection section :  Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView :  UITableView ,  estimatedHeightForHeaderInSection section :  Int) -> CGFloat {
        return 30
    }
}

extension ScheduleController:  CalenderDelegate {
    
    
    func didTapDate(date: String, available: Bool) {
        if available == true {
            calenderView.isHidden = !calenderView.isHidden
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            selectedDate = dateFormatter.date(from: date)!
            showSelectedDataData(date: selectedDate)
        } else {
            //showAlert()
        }
    }
    
    func didChangeMonth(monthIndex: Int, year: Int, calender: CalenderView) {
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            getCalenderData()
        }else{
            showDataOnCalender()
        }
        calenderView.removeFromSuperview()
        if calenderView == nil {
                 calenderView = CalenderView(theme: MyTheme.light)
                calenderView.translatesAutoresizingMaskIntoConstraints=false
        }
        view.addSubview(calenderView)
        calenderView.delegate = self
        calenderView.topAnchor.constraint(equalTo : self.navView.bottomAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive=true
        let screen = UIScreen.main.bounds
        let count = calenderView.numOfDaysInMonth[calenderView.currentMonthIndex-1] + calenderView.firstWeekDayOfMonth - 1
        if count > 35 {
            if UIDevice.current.userInterfaceIdiom == .pad{
                calenderView.heightAnchor.constraint(equalToConstant: ((screen.width / 7) * 5) + 130 ).isActive=true
            }else{
                calenderView.heightAnchor.constraint(equalToConstant: ((screen.width / 7) * 6) + 65 ).isActive=true
            }
        }else{
            if UIDevice.current.userInterfaceIdiom == .pad{
                calenderView.heightAnchor.constraint(equalToConstant: ((screen.width / 7) * 5) + 130 ).isActive=true
            }else{
                calenderView.heightAnchor.constraint(equalToConstant: ((screen.width / 7) * 5) + 65 ).isActive=true
            }
        }
       

    }
    
    fileprivate func showAlert(){
        let alert = UIAlertController(title: "Unavailable", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


