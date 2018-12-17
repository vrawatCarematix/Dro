//
//  DashboardController.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import FoldingCell
import UserNotifications
import NotificationCenter
class DashboardController: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var dashboardTable: UITableView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var warningButton: UIButton!
    
    //MARK:- Variable
    
    var openCell = [String]()
    var timelineArray = [TimelineModel]()
    var userSessionArray = [UserSurveySessionModel]()
    var upcomingArray = [SurveyScheduleDatabaseModel]()
    var dueTodayArray = [SurveyScheduleDatabaseModel]()
    var cellHeights = [String : CGFloat]()
    var firstTimeOnScreen = true
    var isVisible = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        if  CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            //  CustomActivityIndicator.startAnimating( message: "Refreshing...")
            self.getAllSurveyData({ (success, message) in
                //  CustomActivityIndicator.stopAnimating()
                self.getTimeLineData()
                //completionHandler(success , message )
            })
        }else{
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK:- View Life Cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.warningButton.isHidden = true
        labelTitle.setCustomFont()
        deleteExpireMedia()
        
        //App languageChange
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)
        
        //Dashboard Folding cell collapse or expend
        
        NotificationCenter.default.addObserver(self, selector: #selector(expandCell(notification:)), name: NSNotification.Name(rawValue: kDashboardCollapse) , object: nil)
        
        // Network State Change
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkAvailableRefreshData), name: NSNotification.Name(rawValue: kNetworkAvailable) , object: nil)
        
        //Pull to refesh
        self.dashboardTable.addSubview(self.refreshControl)
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.attributedTitle =  NSAttributedString(string: kRefreshing.localisedString().capitalized + "..." , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ,NSAttributedString.Key.font: UIFont(name: kSFSemibold, size:labelTitle.font.pointSize - 2 )!])
        
        if let loggedIn = kUserDefault.value(forKey: kLoggedIn) as? String, loggedIn == kYes {
            if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
                CustomActivityIndicator.startAnimating( message: kLoading.localisedString() + "...")
                self.updateMessage({ (success, message) in
                    self.updateDeclineSurvey({ (success, message) in
                        self.uploadSurveyData({ (success, message) in
                            debugPrint(message)
                            var endTime = Int(Date().timeIntervalSince1970)
                            endTime  += TimeZone.current.secondsFromGMT()
                            let _ = DatabaseHandler.expireOldSuvey(endTime: endTime * 1000)
                            let _ = DatabaseHandler.expireOldUnsheduledSuvey(endTime: endTime * 1000)
                            let _ = DatabaseHandler.deleteAllUploadedSurvey(endTime: endTime * 1000)
                            let _ = DatabaseHandler.enableNewSuvey(startTime :endTime * 1000)
                            self.getTimeLineData()
                        })
                    })
                })
            }else {
                var endTime = Int(Date().timeIntervalSince1970)
                endTime  += TimeZone.current.secondsFromGMT()
                let _ = DatabaseHandler.expireOldSuvey(endTime: endTime * 1000)
                let _ = DatabaseHandler.expireOldUnsheduledSuvey(endTime: endTime * 1000)
                let _ = DatabaseHandler.deleteAllUploadedSurvey(endTime: endTime * 1000)
                let _ = DatabaseHandler.enableNewSuvey(startTime :endTime * 1000)
                getDataFromDb()
            }
        }else{
            firstTimeOnScreen = false
        }
    }
    
    
    func deleteExpireMedia() {
        var endTime = Int(Date().timeIntervalSince1970)
        endTime  += TimeZone.current.secondsFromGMT()
        let mediaArray = DatabaseHandler.getExpireMedia(endTime)
        for media in mediaArray{
            if let name = media.name , name != ""{
                let manager = FileManager.default
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                if let localPath = documentDirectory?.appending("/" + name){
                    if localPath != "/" && localPath != "" && manager.fileExists(atPath: localPath){
                        do {
                            try  manager.removeItem(atPath: localPath)
                            let _ = DatabaseHandler.deleteMediaOfSession(media.sessionScheduleId ?? 0  , questionId:media.questionId ?? 0) 
                        }
                        catch(_){
                            
                        }
                    }
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setText()
        isVisible = true
        kUserDefault.set(AppController.DashboardController, forKey: kRootScreen)
        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        isVisible = false
        
        if openCell.contains("1"){
            let dict = [kOpen : Collapse.close , kCell : DashboardCellType.DueToday] as [String : Any]
            NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
        }
        if openCell.contains("2"){
            let dict1 = [kOpen : Collapse.close , kCell : DashboardCellType.Upcoming] as [String : Any]
            
            NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict1)
        }
        if openCell.contains("3"){
            let dict2 = [kOpen : Collapse.close , kCell : DashboardCellType.Timeline] as [String : Any]
            NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict2)
        }
        if openCell.contains("4"){
            let dict3 = [kOpen : Collapse.close , kCell : DashboardCellType.Statistics] as [String : Any]
            NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict3)
        }
    }
    @objc func networkAvailableRefreshData() {
        if isVisible {
            CustomActivityIndicator.startAnimating( message: kLoading.localisedString() + "...")
        }
        getTimeLineData()
    }
    
    @objc func setText()  {
        labelTitle.text = kDashboard.localisedString()
        if !firstTimeOnScreen{
            var endTime = Int(Date().timeIntervalSince1970)
            endTime  += TimeZone.current.secondsFromGMT()
            let _ = DatabaseHandler.expireOldSuvey(endTime: endTime * 1000)
            let _ = DatabaseHandler.expireOldUnsheduledSuvey(endTime: endTime * 1000)
            let _ = DatabaseHandler.deleteAllUploadedSurvey(endTime: endTime * 1000)
            let _ = DatabaseHandler.enableNewSuvey(startTime :endTime * 1000)
            let currentTime = Int(Date().timeIntervalSince1970)
            if let refreshDate = kUserDefault.value(forKey: kLastDashboardRefresh) as? Int ,   ( refreshDate + 5 * 60 ) < currentTime {
                kUserDefault.set(currentTime, forKey: kLastDashboardRefresh)
                getTimeLineData()
            }else{
                getDataFromDb()
            }
        }else{
            firstTimeOnScreen = false
        }
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        setUpcomingSurveyLocalNotification()
        NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.carematix.DRO.DROWidget")

    }
    
    // removing all Observer
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDashboardCollapse), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNetworkAvailable), object: nil)
        
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        let count = DatabaseHandler.getUnSyncCount()
        if count != 0 {
            showErrorAlert(titleString: kAlert.localisedString(), message: "You have some unsynced data. Please connect to a network to sync data.")
        }else{
            
        }
    }
    
    func getDataFromDb() {
        let unreadCount = DatabaseHandler.getUnreadMessageCount()
        if unreadCount == 0 {
            self.tabBarController?.tabBar.items?[3].badgeValue = nil
        }else{
            self.tabBarController?.tabBar.items?[3].badgeValue = "\(unreadCount)"
        }
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
        let unscheduledSurveyArray = DatabaseHandler.getUncheduledSurvey()
        var count = 0
        for unscheduleSurvey in unscheduledSurveyArray {
            count += 1
            if let surveyID = unscheduleSurvey.surveyId {
                if let unscheduled = DatabaseHandler.getUncheduledIncompleteSurvey(surveyId: surveyID).first {
                    let dueTodayUnschedule = SurveyScheduleDatabaseModel()
                    dueTodayUnschedule.surveyName = (unscheduled.name ?? "") + " ( Optional )"
                    dueTodayUnschedule.progressStatus = unscheduled.progressStatus
                    dueTodayUnschedule.percentageCompleted = unscheduled.percentageComplete
                    dueTodayUnschedule.scheduleType = "UNSCHEDULED"
                    dueTodayUnschedule.surveyID = unscheduled.surveyId
                    if let endDate = unscheduled.scheduledEndTime , endDate != 0 {
                        dueTodayUnschedule.endTime = unscheduled.scheduledEndTime
                    }
                    if let tomorrowDate = dateFormatter.date(from: dateString) , let endDate = dueTodayUnschedule.endTime , endDate != 0 , endDate < ((Int(tomorrowDate.timeIntervalSince1970) + TimeZone.current.secondsFromGMT()) * 1000) {
                        dueTodayArray.append(dueTodayUnschedule)
                    }else{
                        upcomingArray.append(dueTodayUnschedule)
                    }
                }else{
                    let dueTodayUnschedule = SurveyScheduleDatabaseModel()
                    dueTodayUnschedule.surveyName = (unscheduleSurvey.name ?? "") + "( Optional )"
                    dueTodayUnschedule.progressStatus = kNOT_STARTED
                    dueTodayUnschedule.percentageCompleted = 0
                    dueTodayUnschedule.scheduleType = "UNSCHEDULED"
                    dueTodayUnschedule.surveyID = unscheduleSurvey.surveyId
                    dueTodayUnschedule.surveySessionId = Int(Date().timeIntervalSince1970) + count
                    unscheduleSurvey.surveySessionId = dueTodayUnschedule.surveySessionId
                    unscheduleSurvey.progressStatus = kNOT_STARTED
                    unscheduleSurvey.scheduleType = dueTodayUnschedule.scheduleType
                    unscheduleSurvey.surveyLanguage = (kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN")
                    unscheduleSurvey.isUploaded = 1
                    var _ = DatabaseHandler.insertIntoSurveyData(survey: unscheduleSurvey)
                    upcomingArray.append(dueTodayUnschedule)
                }
            }
        }
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            let count = DatabaseHandler.getUnSyncCount()
            if count != 0 {
                self.warningButton.isHidden = false
            }else{
                self.warningButton.isHidden = true
            }
            self.firstTimeOnScreen = false
            self.dashboardTable.reloadData()
        }
        
    }
    
    func getTimeLineData()  {
        
        WebServiceMethods.sharedInstance.getTimeline(0, toRow: 2000){ (success, response, message) in
            DispatchQueue.main.async {
                if success {
                    for timelineData in response{
                        let timelineModel = TimelineModel(jsonObject: timelineData)
                        self.timelineArray.append(timelineModel)
                    }
                    let _ = DatabaseHandler.insertIntoTimeline(timelineArray: self.timelineArray)
                }
                else{
                    //                    if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                    //                        visibleController.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                    //                    }
                }
                
                self.getMessage(completionHandler: { (success,response , message) in
                    self.getDashboardData()
                    
                })
            }
        }
    }
    
    func getDashboardData(){
        WebServiceMethods.sharedInstance.getDashBoardData{ (success, response, message) in
            DispatchQueue.main.async {
                if success {
                    if let userInfo = response["userInfo"] as? [String : Any]{
                        if let userName = userInfo["userName"] as? String{
                            kUserDefault.set(userName, forKey: kuserName)
                        }
                        if let firstName = userInfo[kfirstName] as? String{
                            kUserDefault.set(firstName, forKey: kfirstName)
                        }
                        if let lastName = userInfo[klastName] as? String{
                            kUserDefault.set(lastName, forKey: klastName)
                        }
                        if let userImage = userInfo[kuserImage] as? String{
                            kUserDefault.set(userImage, forKey: kuserImage)
                        }
                        if let userId = userInfo[kUserId] as? Int{
                            kUserDefault.set(userId, forKey: AppConstantString.kUserId)
                        }
                        if let programUserId = userInfo[kProgramUserId] as? Int{
                            kUserDefault.set(programUserId, forKey: AppConstantString.kProgramUserId)
                        }
                        if let lastVisitedDate = userInfo[klastVisitedDate] as? Int{
                            if let savedDate = kUserDefault.value(forKey: klastVisitedDate) as? Int , savedDate < lastVisitedDate {
                                kUserDefault.set(lastVisitedDate, forKey: klastVisitedDate)
                            }
                        }
                        if let programInfo = userInfo[pprogramInfo] as? [String :Any]{
                            if let logoURL = programInfo[klogoURL] as? String {
                                kUserDefault.set(logoURL, forKey: klogoURL)
                            }
                            if let organizationName = programInfo[korganizationName] as? String {
                                kUserDefault.set(organizationName, forKey: korganizationName)
                            }
                            if let programId = programInfo[kprogramId] as? Int {
                                kUserDefault.set(programId, forKey: kprogramId)
                            }
                            if let programName = programInfo[kprogramName] as? String {
                                kUserDefault.set(programName, forKey: kprogramName)
                            }
                        }
                    }
                    if let userSurveySummary = response["userSurveySummary"] as? [String :Any]{
                        let oldCompleteCount = DatabaseHandler.getCompleteSurveyCount()
                        kUserDefault.set(oldCompleteCount, forKey: kOldCompleteCount)
                        
                        let oldExpiredCount = DatabaseHandler.getExpiredSurveyCount()
                        kUserDefault.set(oldExpiredCount, forKey: kOldExpiredCount)
                        
                        let oldDeclineCount = DatabaseHandler.getDeclinedSurveyCount()
                        kUserDefault.set(oldDeclineCount, forKey: kOldDeclineCount)
                        
                        let oldAssignCount = DatabaseHandler.getAssignSurveyCount()
                        kUserDefault.set(oldAssignCount, forKey: kOldAssignCount)
                        if let fromDate = userSurveySummary["fromDate"] as? Int {
                            kUserDefault.set(fromDate, forKey: kfromDate)
                        }
                        if let toDate = userSurveySummary["toDate"] as? Int {
                            kUserDefault.set(toDate, forKey: ktoDate)
                        }
                        if let assigned = userSurveySummary["assigned"] as? Int {
                            kUserDefault.set(assigned, forKey: kassigned)
                        }
                        if let completed = userSurveySummary["completed"] as? Int {
                            kUserDefault.set(completed, forKey: kcompleted)
                        }
                        if let active = userSurveySummary["active"] as? Int {
                            kUserDefault.set(active, forKey: kactive)
                        }
                        if let declined = userSurveySummary["declined"] as? Int {
                            kUserDefault.set(declined, forKey: kdeclined)
                        }
                        if let expired = userSurveySummary["expired"] as? Int {
                            kUserDefault.set(expired, forKey: kexpired)
                        }
                        if let averagePerWeek = userSurveySummary["averagePerWeek"] as? Int {
                            kUserDefault.set(averagePerWeek, forKey: kaveragePerWeek)
                        }
                        if let toDate = userSurveySummary["toDate"] as? Int {
                            kUserDefault.set(toDate, forKey: kLastDashboardUpdate)
                        }
                    }
                    let todaySurvey = DatabaseHandler.getTodaySurveySchedules()
                    for surveys in  todaySurvey {
                        var _ = DatabaseHandler.updateSchedule(progressStatus: kCOMPLETED, isDeclined: surveys.isDeclined ?? 0 , surveySessionId: surveys.surveySessionId ?? 0, actualEndTime: surveys.endTime ?? 0 , percentageCompleted : surveys.percentageCompleted ?? 0 )
                    }
                    self.userSessionArray.removeAll()
                    if let userSurveySessionsArray = response["userSurveySessions"] as? [[String :Any]]{
                        for userSurveySessionsData in userSurveySessionsArray {
                            let userSurveySession = UserSurveySessionModel(jsonObject: userSurveySessionsData)
                            self.userSessionArray.append( userSurveySession)
                        }
                    }
                    var count = 0
                    var responseCount = 0
                    for userSession in self.userSessionArray {
                        count = self.userSessionArray.count
                        guard let scheduleSessionId = userSession.surveySessionInfo.scheduleSessionId  else { continue }
                        if var _ = DatabaseHandler.getSurveySchedules(surveySessionId: scheduleSessionId ){
                            var _ = DatabaseHandler.updateSchedule(progressStatus: userSession.surveySessionInfo.progressStatus ?? "", isDeclined: userSession.surveySessionInfo.declined ?? 0, surveySessionId: scheduleSessionId, actualEndTime: 0 , percentageCompleted : userSession.surveySessionInfo.percentageCompleted ?? 0 )
                        }
                        if scheduleSessionId != 0 , let progressStatus = userSession.surveySessionInfo.progressStatus , progressStatus == "STARTED"{
                            //Scheduled Survey
                            WebServiceMethods.sharedInstance.surveySession(scheduleSessionId, completionHandler: { (success, response, messge) in
                                if success{
                                    let updateSurvey = SurveySubmitModel(jsonObject: response)
                                    var survey = SurveySubmitModel()
                                    if let surveyModel = DatabaseHandler.getSurveyOfSession(surveySessionId:scheduleSessionId ){
                                        survey = surveyModel
                                    }else if let surveyModel = DatabaseHandler.getSurveySchedules(surveySessionId: scheduleSessionId){
                                        survey = DatabaseHandler.getSurvey(surveyId: surveyModel.surveyID ?? 0)
                                        survey.surveySessionId = surveyModel.surveySessionId
                                        survey.scheduledDate = surveyModel.surveyDate
                                        survey.scheduledStartTime = surveyModel.startTime
                                        survey.scheduledEndTime = surveyModel.endTime
                                        survey.programSurveyId = surveyModel.programSurveyId
                                    }
                                    survey.userAnswerLogsJson = updateSurvey.userAnswerLogsJson
                                    survey.userAnswerLogsArray = updateSurvey.userAnswerLogsArray
                                    survey.pageNavigationArray =  updateSurvey.pageNavigationArray
                                    survey.pageNavigationJson  = updateSurvey.pageNavigationJson
                                    survey.timeSpent = updateSurvey.timeSpent
                                    survey.progressStatus = updateSurvey.progressStatus
                                    survey.percentageComplete = updateSurvey.percentageComplete
                                    survey.userScheduleAssignId = updateSurvey.userScheduleAssignId
                                    survey.lastAnswerPageId = updateSurvey.lastAnswerPageId
                                    survey.scheduleType = updateSurvey.scheduleType
                                    survey.unscheduled = updateSurvey.unscheduled
                                    survey.isUploaded = 1
                                    var _ = DatabaseHandler.insertIntoSurveyData(survey: survey)
                                }
                                responseCount += 1
                                if responseCount == count{
                                    DispatchQueue.main.async {
                                        // print("Dashboard --->" + response.description)
                                        CustomActivityIndicator.stopAnimating()
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kReloadUserData), object: nil, userInfo: nil)
                                        self.getDataFromDb()
                                        self.firstTimeOnScreen = false
                                    }
                                }
                                
                            })
                        }else if scheduleSessionId == 0 ,  let userSurveySessionId = userSession.surveySessionInfo.userSurveySessionId  {
                            //Unscheduled Survey
                            
                            WebServiceMethods.sharedInstance.getSurvey(userSurveySessionId, completionHandler: { (success, response, messge) in
                                if success{
                                    // print(response)
                                    if let data = response["userSurveySession"] as? [String :Any] {
                                        var unscheduleSurveyId = 0
                                        if let surveyData = response["survey"] as? [String :Any] , let surveyId = surveyData["id"] as? Int{
                                            unscheduleSurveyId = surveyId
                                        }
                                        var survey = SurveySubmitModel()
                                        if let surveyModel = DatabaseHandler.getUncheduledIncompleteSurvey(surveyId: unscheduleSurveyId).first{
                                            survey = surveyModel
                                        }else if let surveyModel = DatabaseHandler.getUncheduledSurveyOfSurveyId(surveyId: unscheduleSurveyId) {
                                            survey = surveyModel
                                            survey.surveySessionId = Int(Date().timeIntervalSince1970)
                                        }else{
                                            survey.surveySessionId = Int(Date().timeIntervalSince1970)
                                        }
                                        let updateSurvey = SurveySubmitModel(jsonObject: data, sessionId: survey.surveySessionId ?? 0)
                                        survey.userAnswerLogsJson = updateSurvey.userAnswerLogsJson
                                        survey.userAnswerLogsArray = updateSurvey.userAnswerLogsArray
                                        survey.pageNavigationArray =  updateSurvey.pageNavigationArray
                                        survey.pageNavigationJson  = updateSurvey.pageNavigationJson
                                        survey.timeSpent = updateSurvey.timeSpent
                                        survey.progressStatus = updateSurvey.progressStatus
                                        survey.percentageComplete = updateSurvey.percentageComplete
                                        survey.userScheduleAssignId = updateSurvey.userScheduleAssignId
                                        survey.lastAnswerPageId = updateSurvey.lastAnswerPageId
                                        survey.scheduleType = updateSurvey.scheduleType
                                        survey.scheduledDate = updateSurvey.scheduledDate
                                        survey.scheduledStartTime = updateSurvey.scheduledStartTime
                                        survey.scheduledEndTime = updateSurvey.scheduledEndTime
                                        survey.programSurveyId = updateSurvey.programSurveyId
                                        survey.surveyLanguage = (kUserDefault.value(forKey: kselectedLanguage) as? String ?? "EN")
                                        survey.isUploaded = 1
                                        var _ = DatabaseHandler.insertIntoSurveyData(survey: survey)
                                    }
                                }
                                responseCount += 1
                                if responseCount == count{
                                    DispatchQueue.main.async {
                                        // print("Dashboard --->" + response.description)
                                        CustomActivityIndicator.stopAnimating()
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kReloadUserData), object: nil, userInfo: nil)
                                        self.getDataFromDb()
                                        self.firstTimeOnScreen = false
                                    }
                                }
                            })
                        }else{
                            responseCount += 1
                        }
                    }
                    if responseCount == count{
                        self.firstTimeOnScreen = false
                        CustomActivityIndicator.stopAnimating()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kReloadUserData), object: nil, userInfo: nil)
                        self.getDataFromDb()
                    }
                }else{
                    DispatchQueue.main.async {
                        // print("Dashboard --->" + response.description)
                        CustomActivityIndicator.stopAnimating()
                        self.firstTimeOnScreen = false
                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                            visibleController.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                        }
                    }
                }
            }
        }
    }
}

extension DashboardController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.allowsSelection = false
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DashboardHeaderCell) as? DashboardHeaderCell
            if let firstName = kUserDefault.value(forKey: kfirstName) as? String {
                if let lastName = kUserDefault.value(forKey: klastName) as? String {
                    cell?.userName.text = kWelcome.localisedString() + " " + firstName + " " + lastName
                }else{
                    cell?.userName.text = kWelcome.localisedString() + " "  + firstName
                }
            }else{
                cell?.userName.text = ""
            }
            if let lastVisit = kUserDefault.value(forKey: klastVisitedDate) as? Int {
                let endDate = Date(timeIntervalSince1970: TimeInterval(lastVisit / 1000))
                let dateFormatter = DateFormatter()
                if let selectedLanguageCode = kUserDefault.value(forKey: kselectedLanguage) as? String {
                    dateFormatter.locale = Locale(identifier: selectedLanguageCode)
                }else{
                    dateFormatter.locale = Locale(identifier: "EN")
                }
                dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
                
                let lastString =  NSMutableAttributedString(string:   kLast_Visit.localisedString(), attributes: [NSAttributedString.Key.foregroundColor:UIColor.darkGray])
                
                lastString.append(NSAttributedString(string: dateFormatter.string(from: endDate)))
                cell?.labelLastLogin.attributedText = lastString
                
            }else{
                cell?.labelLastLogin.text = ""
            }
            cell?.selectionStyle = .none
            return cell!
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DashboardDueTodayCell, for: indexPath) as? DashboardDueTodayCell
            cell?.imgHalf.image = #imageLiteral(resourceName: "clockHalf")
            // DispatchQueue.main.async {
            cell?.maximumHeight = tableView.frame.size.height - 20
            cell?.dueTodayArray = dueTodayArray
            cell?.setText()
            cell?.expendTable.reloadData()
            cell?.selectionStyle = .none
            //}
            if  let height =  cellHeights["\(indexPath.row)"] , height < ((cell?.frame.size.height) ?? 0 ) {
                cellHeights["\(indexPath.row)"] = (cell?.frame.size.height) ?? 0
            }
            return cell!
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DashboardUpcomingCell, for: indexPath) as? DashboardUpcomingCell
            //cell?.userSessionArray = self.userSessionArray
            cell?.upcomingArray = upcomingArray
            cell?.setText()
            cell?.selectionStyle = .none
            
            cell?.maximumHeight = tableView.frame.size.height - 20
            cell?.expendTable.reloadData()
            if  let height =  cellHeights["\(indexPath.row)"] , height < ((cell?.frame.size.height) ?? 0 ) {
                cellHeights["\(indexPath.row)"] = (cell?.frame.size.height) ?? 0
            }
            return cell!
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DashboardTimelineCell, for: indexPath) as? DashboardTimelineCell
            cell?.timelineArray = self.timelineArray
            cell?.configCell(array: self.timelineArray)
            cell?.selectionStyle = .none
            cell?.maximumHeight = tableView.frame.size.height - 20
            cell?.expendTable.reloadData()
            cellHeights["\(indexPath.row)"] = (cell?.frame.size.height) ?? 0
            
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DashboardStatisticsCell, for: indexPath) as? DashboardStatisticsCell
            cell?.selectionStyle = .none
            cell?.setText()
            cellHeights["\(indexPath.row)"] = (cell?.frame.size.height) ?? 0
            return cell!
        }
    }
}

extension DashboardController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if  let height =  cellHeights["\(indexPath.row)"] , height != 0{
            return height
        }
        return 50
    }
    
    @objc func expandCell( notification :  Notification)  {
        
        if let dict = notification.object as? [String : Any], let cellType = dict[kCell] as? DashboardCellType {
            var indexPath = IndexPath(row: 4, section: 0)
            if cellType == .DueToday {
                indexPath = IndexPath(row: 1, section: 0)
            }else if cellType == .Upcoming {
                indexPath = IndexPath(row: 2, section: 0)
            }else if cellType == .Timeline {
                indexPath = IndexPath(row: 3, section: 0)
            }
            if indexPath.row == 0 {
                return
            }
            guard let cell = dashboardTable.cellForRow(at: indexPath) as? FoldingCell else {
                return // or fatalError() or whatever
            }
            if cell.isAnimating() {
                return
            }
            if openCell.contains("\(indexPath.row)"){
                //COLLAPSE OPEN CELL
                if indexPath.row == 1 {
                    let cell1 = cell as! DashboardDueTodayCell
                    openCell.remove(at: openCell.index(of: "\(indexPath.row)")!)
                    collapseCellAnimation(cell: cell1, duration: 0.2)
                }else if indexPath.row == 2 {
                    let cell1 = cell as! DashboardUpcomingCell
                    openCell.remove(at: openCell.index(of: "\(indexPath.row)")!)
                    collapseCellAnimation(cell: cell1, duration: 0.2)
                }else if indexPath.row == 3 {
                    let cell1 = cell as! DashboardTimelineCell
                    openCell.remove(at: openCell.index(of: "\(indexPath.row)")!)
                    collapseCellAnimation(cell: cell1, duration: 0.2)
                }else if indexPath.row == 4 {
                    let cell1 = cell as! DashboardStatisticsCell
                    openCell.remove(at: openCell.index(of: "\(indexPath.row)")!)
                    collapseCellAnimation(cell: cell1, duration: 0.2)
                }
                self.dashboardTable.isScrollEnabled = true
            }else{
                //EXPAND
                
                if openCell.count == 0 {
                    self.expand(indexPath: indexPath, cell: cell)
                }else{
                    for rowString in openCell{
                        if let row = Int(rowString) {
                            let indexPath1 = IndexPath(row: row, section: 0)
                            if let cell1 = self.dashboardTable.cellForRow(at: indexPath1) as? DashboardDueTodayCell{
                                NSLayoutConstraint.deactivate([cell1.bottomConstrient])
                                collapseCellAnimation(cell: cell1, duration: 0.2) {
                                    self.expand(indexPath: indexPath, cell: cell)
                                }
//                                cell1.unfold(false, animated: false) {
//                                    self.expand(indexPath: indexPath, cell: cell)
//                                }
                                //self.expand(indexPath: indexPath, cell: cell)

                            }else if let cell1 = self.dashboardTable.cellForRow(at: indexPath1) as? DashboardUpcomingCell{
                                NSLayoutConstraint.deactivate([cell1.bottomConstrient])
                                collapseCellAnimation(cell: cell1, duration: 0.2) {
                                    self.expand(indexPath: indexPath, cell: cell)
                                    
                                }
//                                cell1.unfold(false, animated: false) {
//                                    self.expand(indexPath: indexPath, cell: cell)
//                                }
                            }else if let cell1 = self.dashboardTable.cellForRow(at: indexPath1) as? DashboardTimelineCell{
                                NSLayoutConstraint.deactivate([cell1.bottomConstrient])
                                collapseCellAnimation(cell: cell1, duration: 0.2) {
                                    self.expand(indexPath: indexPath, cell: cell)
                                    
                                }
//                                cell1.unfold(false, animated: false) {
//                                    self.expand(indexPath: indexPath, cell: cell)
//                                }
                            }else if let cell1 = self.dashboardTable.cellForRow(at: indexPath1) as? DashboardStatisticsCell{
                                NSLayoutConstraint.deactivate([cell1.bottomConstrient])
                                collapseCellAnimation(cell: cell1, duration: 0.2) {
                                    self.expand(indexPath: indexPath, cell: cell)
                                    
                                }
//                                cell1.unfold(false, animated: false) {
//                                    self.expand(indexPath: indexPath, cell: cell)
//                                }
                            }
                        }
                    }
                }
                //self.expand(indexPath: indexPath, cell: cell)

            }
        }
    }
    
    func expand( indexPath: IndexPath , cell :FoldingCell)  {
        self.dashboardTable.beginUpdates()
        self.dashboardTable.endUpdates()
        openCell.removeAll()
        if indexPath.row == 1 {
            if dueTodayArray.count == 0{
                self.dashboardTable.isScrollEnabled = true
                self.view.showToast(toastMessage: "No DROs due today ", duration: 1.0)
            }else{
                let cell1 = cell as! DashboardDueTodayCell
                self.dashboardTable.isScrollEnabled = false
                self.openCell.append("\(indexPath.row)")
                NSLayoutConstraint.activate([cell1.bottomConstrient])
                expandCellAnimation(cell: cell1, duration: 0.2 )
            }
        }else if indexPath.row == 2 {
            if upcomingArray.count == 0{
                self.dashboardTable.isScrollEnabled = true
                self.view.showToast(toastMessage: "No upcoming DROs ", duration: 1.0)
            }else{
                let cell1 = cell as! DashboardUpcomingCell
                self.dashboardTable.isScrollEnabled = false
                openCell.append("\(indexPath.row)")
                NSLayoutConstraint.activate([cell1.bottomConstrient])
                expandCellAnimation(cell: cell1, duration: 0.3)
            }
        }else if indexPath.row == 3 {
            let timelineData = DatabaseHandler.getAllTimeline()
            if timelineData.count == 0{
                self.dashboardTable.isScrollEnabled = true
                self.view.showToast(toastMessage: "No data available", duration: 1.0)
            }else{
                self.dashboardTable.isScrollEnabled = false
                let cell1 = cell as! DashboardTimelineCell
                NSLayoutConstraint.activate([cell1.bottomConstrient])
                openCell.append("\(indexPath.row)")
                expandCellAnimation(cell: cell1, duration: 0.4)
            }
        }else if indexPath.row == 4 {
            let cell1 = cell as! DashboardStatisticsCell
            openCell.append("\(indexPath.row)")
            NSLayoutConstraint.activate([cell1.bottomConstrient])
            self.dashboardTable.beginUpdates()
            self.dashboardTable.endUpdates()
            UIView.animate(withDuration:0.2, delay: 0, options: .curveEaseIn, animations: { () -> Void in
                var origin = cell1.frame.origin
                origin.y -= cell1.frame.size.height
                //self.dashboardTable.contentOffset = origin
            }, completion: { (success) in
                self.dashboardTable.beginUpdates()
                self.dashboardTable.endUpdates()
                cell.unfold(true, animated: true) {
                }
            })
        }
    }
    
    func expandCellAnimation(cell :UITableViewCell , duration :TimeInterval)  {
        
        guard let cell = cell as? FoldingCell else {
            return // or fatalError() or whatever
        }
        UIView.animate(withDuration:duration, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            self.dashboardTable.contentOffset = cell.frame.origin
            
        }, completion: { (success) in
            self.dashboardTable.beginUpdates()
            self.dashboardTable.endUpdates()
            cell.unfold(true, animated: true) {}
            
        })
    }
    
    func collapseCellAnimation(cell :UITableViewCell , duration :TimeInterval, completion: (() -> Void)? = nil)  {
        
        guard let cell = cell as? FoldingCell else {
            return // or fatalError() or whatever
        }
        cell.unfold(false, animated: true) {
            if let cell1 = cell as? DashboardDueTodayCell{
                NSLayoutConstraint.deactivate([cell1.bottomConstrient])
                
            }else if let cell1 = cell as? DashboardUpcomingCell{
                NSLayoutConstraint.deactivate([cell1.bottomConstrient])
                
            }else if let cell1 = cell as? DashboardTimelineCell{
                NSLayoutConstraint.deactivate([cell1.bottomConstrient])
                
            }else if let cell1 = cell as? DashboardStatisticsCell{
                NSLayoutConstraint.deactivate([cell1.bottomConstrient])
            }
            self.dashboardTable.beginUpdates()
            self.dashboardTable.endUpdates()
            if let complitionBlock = completion{
                complitionBlock()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let cell as FoldingCell = cell {
            if openCell.contains("\(indexPath.row)"){
                cell.unfold(true, animated: false, completion: nil)
            }else{
                cell.unfold(false, animated: false, completion: nil)
            }
        }
    }
}
