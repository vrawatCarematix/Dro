//
//  QutionnaireController.swift
//  DROapp
//
//  Created by Carematix on 09/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
// https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html

import UIKit
import AVFoundation
import LGSideMenuController

//MARK:- Calender Theme
class QuestionAnswer {
    var question : Int?
    var answer : Int?
}

class QuestionnaireController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelPrevious: UILabel!
    @IBOutlet var labelNext: UILabel!
    @IBOutlet var labelQuestionNumber: UILabel!
    @IBOutlet var labelDueBy: UILabel!
    @IBOutlet var labelQuestionnaireType: UILabel!
    @IBOutlet var previousView: UIView!
    @IBOutlet var nextView: UIView!
    @IBOutlet var buttonClose: UIButton!
    @IBOutlet var progressViewHeight: NSLayoutConstraint!
    @IBOutlet var questionProgressView: UIProgressView!
    @IBOutlet var questionTable: UITableView!
    
    //MARK:- Variables
    
    var survey = SurveySubmitModel()
    var imageDropDownArray = [Int]()
    var questionArray = [QuestionsModel]()
    var answerArray = [AnswersModel]()
    var currentPageId = 0
    var nextPageId = 0
    var previousPageId = 0
    var questionNumber = 0
    var pageNavigationArray = [PageNavigations]()
    var pageNavigation = PageNavigations()
    var questionaireTitle :String?
    var pagesArray = [PagesModel]()
    var selectedPageModel = PagesModel()
    var selectedQuestionModel = QuestionsModel()
    var selectedAnswerModel = AnswersModel()
    var loadNewCell = true
    var userAnswerArray = [UserAnswerLogs]()
    var tempUserAnswerArray = [UserAnswerLogs]()
    var backToPrevious = false
    var userAnswer = UserAnswerLogs()
    var questionAnswerArray = [String : QuestionAnswer]()
    var tableSectionArray = [Int : CGFloat]()
//    var characterArray = [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]
   // let aScalars = "a".unicodeScalars
   // let aCode =  "a".unicodeScalars[ "a".unicodeScalars.startIndex].value
    
    let letters: [Character] = (0..<26).map {
        i in Character(UnicodeScalar("a".unicodeScalars[ "a".unicodeScalars.startIndex].value + i)!)
    }
    //MARK:- View Life Cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
      print(letters)
        if let _ = survey.startTime ,   survey.startTime != 0 {
            
        }else{
            var startTime = Int(Date().timeIntervalSince1970)
            startTime  += TimeZone.current.secondsFromGMT()
            survey.startTime = startTime * 1000
        }
        buttonClose.setCustomFont()
        let textCellNib = UINib(nibName: ReusableIdentifier.TermTextCell, bundle: nil)
        questionTable.register(textCellNib, forCellReuseIdentifier: ReusableIdentifier.TermTextCell)
        
        let videoCellNib = UINib(nibName: ReusableIdentifier.TermVideoCell, bundle: nil)
        questionTable.register(videoCellNib, forCellReuseIdentifier: ReusableIdentifier.TermVideoCell)
        
        let audioCellNib = UINib(nibName: ReusableIdentifier.TermAudioCell, bundle: nil)
        questionTable.register(audioCellNib, forCellReuseIdentifier: ReusableIdentifier.TermAudioCell)
        
        let imageCellNib = UINib(nibName: ReusableIdentifier.TermImageCell, bundle: nil)
        questionTable.register(imageCellNib, forCellReuseIdentifier: ReusableIdentifier.TermImageCell)
        
        let termCellNib = UINib(nibName: ReusableIdentifier.TermWebCell, bundle: nil)
        questionTable.register(termCellNib, forCellReuseIdentifier: ReusableIdentifier.TermWebCell)
        let termSingleTextNib = UINib(nibName: ReusableIdentifier.TermSingleTextCell, bundle: nil)
        questionTable.register(termSingleTextNib, forCellReuseIdentifier: ReusableIdentifier.TermSingleTextCell)
        
        labelTitle.text = survey.name
        if let programName = survey.programName  {
            labelQuestionnaireType.text  = (survey.organizationName ?? "") + " : " + programName
        }
        pagesArray = survey.pagesArray
        
        var dueString = "Due by"
        if let dashboard = kUserDefault.value(forKey: kdashboard) as? [String : Any] {
            if let due = dashboard["26"] as? String {
                dueString = due
            }
        }
        if let endTime = survey.scheduledEndTime , endTime != 0 {
            let localDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000) )
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: localDate)
            labelDueBy.text =  dueString + " " + dateString
        }else{
     
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: Date())
            labelDueBy.text =  dueString + " " + dateString
        }
        pageNavigationArray = survey.pageNavigationArray
        userAnswerArray = survey.userAnswerLogsArray
        if let percentageComplete = survey.percentageComplete , percentageComplete > 0{
            questionProgressView.setProgress( Float(percentageComplete / 100), animated: true)
        }

        if let pageid = survey.lastAnswerPageId , pageid != 0 {
            let pages =  pagesArray.filter({ ($0.id ?? 0) == pageid })
            if  pages.count > 0 {
                selectedPageModel = pages[0]
                currentPageId = selectedPageModel.id ?? 0
                nextPageId = selectedPageModel.nextPageId ?? 0
                if  pageNavigationArray.filter({ ($0.currentPageId ?? 0) == currentPageId}).count > 0{
                    pageNavigation = pageNavigationArray.filter({ ($0.currentPageId ?? 0) == currentPageId })[0]
                    previousPageId = pageNavigation.previousPageId ?? 0
                    currentPageId = pageNavigation.currentPageId ?? 0
                    nextPageId = pageNavigation.nextPageId ?? 0
                }else if  pageNavigationArray.filter({ ($0.nextPageId ?? 0) == currentPageId}).count > 0{
                    let pageNavigation = PageNavigations()
                    pageNavigation.currentPageId = currentPageId
                    pageNavigation.nextPageId = nextPageId
                    pageNavigation.previousPageId = pageNavigationArray.filter({ ($0.nextPageId ?? 0) == currentPageId })[0].currentPageId
                    previousPageId = pageNavigation.previousPageId ?? 0
                    pageNavigationArray.append(pageNavigation)
                    
                }
                if let pageNumber = selectedPageModel.pageNumber{
                    questionNumber = pageNumber - 1
                }else{
                    questionNumber = 0
                }
            }
        }else{
            if pagesArray.count > 0 {
                let pages =  pagesArray.filter({ $0.pageNumber ==  1})
                
              //  let pages =  pagesArray.filter({ $0.id ==  pagesArray.compactMap({$0.id}).min() })

                if  pages.count > 0 {
                    selectedPageModel = pages[0]
                    currentPageId = selectedPageModel.id ?? 0
                    survey.lastAnswerPageId = selectedPageModel.id
                    let pageNavigation = PageNavigations()
                    pageNavigation.currentPageId = currentPageId
                    pageNavigation.previousPageId = 0
                    previousPageId = 0
                    nextPageId = selectedPageModel.nextPageId ?? 0
                    pageNavigation.nextPageId = nextPageId
                    pageNavigationArray = [pageNavigation]
                    questionNumber = selectedPageModel.pageNumber ?? 0
                    questionNumber -= 1
                }
            }
        }
        var _ = DatabaseHandler.insertIntoSurveyData(survey: survey)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)
        updateQuestionLabel()
        updateProgressBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenuController?.isLeftViewSwipeGestureEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        sideMenuController?.isLeftViewSwipeGestureEnabled = true

    }
    
    @objc func updateLanguage(){
        var closeString = "Close"
        if let header = kUserDefault.value(forKey: kheader) as? [String : Any] {
                if let close = header["10"] as? String {
                closeString = close
            }
        }
        buttonClose.setTitle(closeString.capitalized, for: .normal)
        updateQuestionLabel()
        questionTable.reloadData()
    }
    
    @objc func updateQuestionLabel()  {
        var questionString = "Question"
        if survey.type?.lowercased() == "TRAINING".lowercased(){
            questionString = "Page"
        }else{
            if let surveyDetail = kUserDefault.value(forKey: ksurvey_detail) as? [String : Any] {
                if let question = surveyDetail["13"] as? String {
                    questionString = question.capitalized
                }
            }
        }
        var ofString = "of"
        if let surveyDetail = kUserDefault.value(forKey: ksurvey_detail) as? [String : Any] {
            if let question = surveyDetail["13"] as? String {
                questionString = question.capitalized
            }
            if let of = surveyDetail["14"] as? String {
                ofString = of
            }
        }
        labelQuestionNumber.text = questionString + " \(questionNumber + 1 ) " + ofString + " \(survey.pagesArray.count)"
        if previousPageId == 0 || questionNumber == 0 {
            previousView.isHidden = true
        }else{
            previousView.isHidden = false
        }        
        if let surveyDetail = kUserDefault.value(forKey: ksurvey_detail) as? [String : Any] , let previous = surveyDetail["16"] as? String {
            labelPrevious.text = previous.capitalized
        }else{
            labelPrevious.text = "Previous"
        }
        if questionNumber == survey.pagesArray.count - 1 {
            if let surveyDetail = kUserDefault.value(forKey: ksurvey_detail) as? [String : Any] , let submit = surveyDetail["18"] as? String {
                labelNext.text = submit.capitalized
            }else{
                labelNext.text = "Submit"

            }
        }else{
            if let surveyDetail = kUserDefault.value(forKey: ksurvey_detail) as? [String : Any] , let next = surveyDetail["17"] as? String {
                labelNext.text = next.capitalized
            }else{
                labelNext.text = "Next"
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
        
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopPlaying"), object: nil)
    }
    
    func initialSetup()  {
        labelTitle.setCustomFont()
        labelNext.setCustomFont()
        labelDueBy.setCustomFont()
        labelPrevious.setCustomFont()
        labelQuestionNumber.setCustomFont()
        labelQuestionnaireType.setCustomFont()
        if UIDevice.current.userInterfaceIdiom == .pad {
            progressViewHeight.constant = CGFloat(self.view.getCustomFontSize(size: -1))
        }else{
            progressViewHeight.constant = CGFloat(self.view.getCustomFontSize(size: 4))
        }
        questionProgressView.layer.cornerRadius = progressViewHeight.constant / 2
        questionProgressView.clipsToBounds = true
        self.questionTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.questionTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if newSize.height > (self.questionTable.frame.size.height){
                        self.questionTable.isScrollEnabled = true
                    }else{
                        self.questionTable.isScrollEnabled = false
                    }
                }
            }
        }
    }
    
    func changePage(pageid : Int)  {
        loadNewCell = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopPlaying"), object: nil)
        tableSectionArray.removeAll()
        imageDropDownArray.removeAll()
        if pageid != 0 {
            let pages =  pagesArray.filter({ ($0.id ?? 0) == pageid })
            if  pages.count > 0 {
                selectedPageModel = pages[0]
                if  pageNavigationArray.filter({ ($0.currentPageId ?? 0) == pageid}).count > 0 {
                    pageNavigation = pageNavigationArray.filter({ ($0.currentPageId ?? 0) == pageid })[0]
                    previousPageId = pageNavigation.previousPageId ?? 0
                    currentPageId = pageNavigation.currentPageId ?? 0
                    nextPageId = pageNavigation.nextPageId ?? 0
                    survey.lastAnswerPageId = pageNavigation.currentPageId
                }else{
                    survey.lastAnswerPageId = selectedPageModel.currentPageId
                    let pageNavigation = PageNavigations()
                    pageNavigation.currentPageId = selectedPageModel.currentPageId
                    pageNavigation.previousPageId = currentPageId
                    pageNavigation.nextPageId = selectedPageModel.nextPageId
                    pageNavigationArray.append(pageNavigation)
                    previousPageId = currentPageId
                    nextPageId = pageNavigation.nextPageId ?? 0
                    currentPageId = pageNavigation.currentPageId ?? 0
                    survey.lastAnswerPageId = pageNavigation.currentPageId

                }
            }
        }
    }
    
    //MARK:- Button Action

    @IBAction func close(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopPlaying"), object: nil)

        if let retake = survey.retakeAllowed , retake == 0 {
            let view = CustomWarningAlert.instanceFromNib( title : "Warning!" ,message: "If you leave this questionnaire, it will no longer be available.\n \n Would you like to leave this questionnaire?") as? CustomWarningAlert
            view?.delegate = self
            UIApplication.shared.keyWindow?.addSubview(view!)
        }else{
            backToPrevious = false
            if let autoSave = survey.autoSave , autoSave == 0 {
                let view = CustomWarningAlert.instanceFromNib( title : "Warning!" ,message: "If you leave this questionnaire, you will loose your progress and have to start from scratch.\n \n Would you like to leave this questionnaire?") as? CustomWarningAlert
                view?.delegate = self
                UIApplication.shared.keyWindow?.addSubview(view!)
            }else{
                var dueString = ""
                
                if var endTime = survey.scheduledEndTime {
                    endTime  -= (TimeZone.current.secondsFromGMT() * 1000)
                    let localDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a 'on' EEEE, MMMM dd, yyyy"
                    dueString = dateFormatter.string(from: localDate)
                }
                let view = CustomWarningAlert.instanceFromNib( title : "Saving Your Progress!" ,message: "You have chosen to exit. We are saving you progress. You will be able to continue from this question on your next visit.\n Please do not forget to complete this questionnaire by " + dueString ) as? CustomWarningAlert
                view?.delegate = self
                UIApplication.shared.keyWindow?.addSubview(view!)
            }
        }
    }
    
    func resetSurvey()  {
        survey.lastSubmissionTime = 0
        survey.endTime = 0
        survey.startTime = 0
        survey.pageNavigationArray.removeAll()
        survey.timeSpent = 0
        let pageNavigationJson = [[String : Any]]()
        survey.pageNavigationJson = pageNavigationJson
        survey.userAnswerLogsArray.removeAll()
        let userAnswerLogsJson = [[String : Any]]()
        survey.lastAnswerPageId = 0
        survey.userAnswerLogsJson = userAnswerLogsJson
        survey.progressStatus = kNOT_STARTED
        survey.percentageComplete = 0
        survey.isUploaded = 0
        var _ = DatabaseHandler.insertIntoSurveyData(survey: survey)
        var _ = DatabaseHandler.updateSchedule(progressStatus: self.survey.progressStatus ?? "", isDeclined: self.survey.declined ?? 0 , surveySessionId: self.survey.surveySessionId ?? 0, actualEndTime: 0 , percentageCompleted : self.survey.percentageComplete ?? 0 )
        if backToPrevious {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }        
    }
    
    func expireSurvey()  {
        let declineController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.DeclineController) as! DeclineController
        declineController.surveyArray = [survey]
        declineController.questionController = self
        self.present(declineController, animated: true, completion: nil)
    }
    
    func saveSurvey()  {
        var endTime = Int(Date().timeIntervalSince1970)
        endTime  += TimeZone.current.secondsFromGMT()
        survey.lastSubmissionTime = endTime * 1000
        survey.endTime = 0
        survey.pageNavigationArray = pageNavigationArray
        survey.timeSpent = (survey.timeSpent ?? 0.0) + Double((survey.lastSubmissionTime ?? 1) / 1000 ) - Double((survey.startTime ?? 1) / 1000 )
        
        var pageNavigationJson = [[String : Any]]()
        for page in pageNavigationArray {
            let dict = page.getDict()
            pageNavigationJson.append(dict)
        }
        survey.pageNavigationJson = pageNavigationJson
        survey.userAnswerLogsArray = userAnswerArray
        var userAnswerLogsJson = [[String : Any]]()
        for page in userAnswerArray {
            if let questionId = page.questionId , questionId != 0 {
                let dict = page.getDict()
                userAnswerLogsJson.append(dict)
            }
        }
        survey.userAnswerLogsJson = userAnswerLogsJson
        survey.progressStatus = kSTARTED
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            CustomActivityIndicator.startAnimating( message: "Saving...")
            submitSurvey(survey) { (success, response, message) in
                DispatchQueue.main.async {
                    CustomActivityIndicator.stopAnimating()
                    if success{
                        self.survey.isUploaded = 1
                        var _ = DatabaseHandler.insertIntoSurveyData(survey: self.survey)
                        var _ = DatabaseHandler.updateSchedule(progressStatus: self.survey.progressStatus ?? "", isDeclined: self.survey.declined ?? 0 , surveySessionId: self.survey.surveySessionId ?? 0 , actualEndTime: 0 , percentageCompleted : self.survey.percentageComplete ?? 0 )
                        if self.backToPrevious {
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }else{
                        self.survey.isUploaded = 0
                        var _ = DatabaseHandler.insertIntoSurveyData(survey: self.survey)
                        var _ = DatabaseHandler.updateSchedule(progressStatus: self.survey.progressStatus ?? "", isDeclined: self.survey.declined ?? 0 , surveySessionId: self.survey.surveySessionId ?? 0 , actualEndTime: 0 , percentageCompleted : self.survey.percentageComplete ?? 0 )
                        self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                    }
                }
            }
        }else{
            survey.isUploaded = 0
            var _ = DatabaseHandler.insertIntoSurveyData(survey: survey)
            var _ = DatabaseHandler.updateSchedule(progressStatus: self.survey.progressStatus ?? "", isDeclined: self.survey.declined ?? 0 , surveySessionId: self.survey.surveySessionId ?? 0, actualEndTime: 0 , percentageCompleted : self.survey.percentageComplete ?? 0 )
            if backToPrevious {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopPlaying"), object: nil)

        if let retake = survey.retakeAllowed , retake == 0 {
            let view = CustomWarningAlert.instanceFromNib( title : "Warning!" ,message: "If you leave this questionnaire, it will no longer be available.\n \n Would you like to leave this questionnaire?") as? CustomWarningAlert
            view?.delegate = self
            UIApplication.shared.keyWindow?.addSubview(view!)
        }else{
            backToPrevious = true

            if let autoSave = survey.autoSave , autoSave == 0 {
                let view = CustomWarningAlert.instanceFromNib( title : "Warning!" ,message: "If you leave this questionnaire, you will loose your progress and have to start from scratch.\n \n Would you like to leave this questionnaire?") as? CustomWarningAlert
                view?.delegate = self
                UIApplication.shared.keyWindow?.addSubview(view!)
            }else{
                var dueString = ""
                if var endTime = survey.scheduledEndTime {
                    endTime  -= (TimeZone.current.secondsFromGMT() * 1000)
                    let localDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a 'on' EEEE, MMMM dd, yyyy"
                    dueString = dateFormatter.string(from: localDate)
                }
                let view = CustomWarningAlert.instanceFromNib( title : "Saving Your Progress!" ,message: "You have chosen to exit. We are saving you progress. You will be able to continue from this question on your next visit.\n Please do not forget to complete this questionnaire by " + dueString ) as? CustomWarningAlert
                view?.delegate = self
                UIApplication.shared.keyWindow?.addSubview(view!)
            }
            
        }
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {

        let sectionArray =  selectedPageModel.sectionArray
        if  sectionArray.count > 0  {
            var enableNext = false
            var helpText = ""
            for section in sectionArray {
              var row = 0
                for question in section.questionArray {
                    enableNext = false
                    row += 1
                    if userAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                        if tempUserAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                            userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                        }else{
                            userAnswer = userAnswerArray.filter({ $0.questionId == question.id })[0]
                            tempUserAnswerArray.append(userAnswer)
                            userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                        }
                    }else{
                        if tempUserAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                            userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                        }else{
                            userAnswer.questionId = question.id
                            tempUserAnswerArray.append(userAnswer)
                            userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                        }
                    }
                    helpText = question.helpText ?? ""
                    if question.answerType == ViewType.kRadio.rawValue {
                        if let _ = userAnswer.choiceId{
                            enableNext = true
                        }
                    }else if question.answerType == ViewType.kCheck.rawValue {
                        if let text = userAnswer.answerFreeText , text.trimmingCharacters(in: .whitespaces) != ""{
                            enableNext = true
                        }
                    }else if question.answerType == ViewType.kTextbox.rawValue ||  question.answerType == ViewType.kNumeric.rawValue{
                        if let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as? TextAnswerCell {
                            if cell.answerTextfield.text?.trimmingCharacters(in: .whitespaces) != "" {
                                userAnswer.answerFreeText = cell.answerTextfield.text
                                enableNext = true
                            }
                        }
                    }else if question.answerType == ViewType.kBP.rawValue {
                        if let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as? BPAnswerCell {
                            if cell.systolicTextfield.text?.trimmingCharacters(in: .whitespaces) != "" && cell.diastolicTextfield.text?.trimmingCharacters(in: .whitespaces) != ""{
                                if let text = cell.systolicTextfield.text , let systolic = Int(text ) , systolic < 50 {
                                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                                            visibleController.view.showToast(toastMessage: "Systolic cannot be less than 50", duration: 2.0)
                                        }
                                    return
                                }else if let text = cell.diastolicTextfield.text , let diastolic = Int(text) , diastolic < 50 {
                                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                                            visibleController.view.showToast(toastMessage: "Diastolic cannot be less than 50", duration: 2.0)
                                        }
                                    return
                                }else{
                                    userAnswer.answerFreeText = cell.systolicTextfield.text! + "/" + cell.diastolicTextfield.text!
                                    enableNext = true
                                }
                            }
                        }
                    }else if question.answerType == ViewType.kDate.rawValue {
                        if let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as? DateAnswerCell {
                            if let text = cell.labelDate.text?.trimmingCharacters(in: .whitespaces) , text != "" , text != "Select Date"{
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMMM dd, yyyy"
                                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                                if let localDate = dateFormatter.date(from: text) {
                                    let dateFormatter1 = DateFormatter()
                                    dateFormatter1.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
                                    userAnswer.answerFreeText = dateFormatter1.string(from: localDate)
                                    enableNext = true
                                }
                            }
                        }
                    }else if question.answerType == ViewType.kRating.rawValue {
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as! RatingAnswerCell
                        if cell.ratingView.rating != 0{
                            userAnswer.answerFreeText = "\(Int(cell.ratingView.rating))"
                            enableNext = true
                        }
                    }else if question.answerType == ViewType.kRichtext.rawValue {
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as! TextViewAnswerCell
                        if cell.richTextView.text?.trimmingCharacters(in: .whitespaces) != "Enter text"{
                            userAnswer.answerFreeText = cell.richTextView.text
                            enableNext = true
                        }
                    }else if  question.answerType == ViewType.kAge.rawValue {
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as! TextAnswerCell
                        if cell.answerTextfield.text?.trimmingCharacters(in: .whitespaces) != ""{
                            if let text = cell.answerTextfield.text , let age = Int(text ) , age == 0 {
                                if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                                    visibleController.view.showToast(toastMessage: "Age cannot be  0", duration: 2.0)
                                }
                                return
                            }else{
                                userAnswer.answerFreeText = cell.answerTextfield.text
                                enableNext = true
                            }
                        }
                    }
                    else if question.answerType == ViewType.kTime.rawValue {
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as!  TimeAnswerCell
                        if let text = cell.labelTime.text?.trimmingCharacters(in: .whitespaces) , text != "" , text != "Select time"{
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "hh:mm a"
                            if let localDate = dateFormatter.date(from: text) {
                                let dateFormatter1 = DateFormatter()
                                dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
                                dateFormatter1.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
                                userAnswer.answerFreeText = dateFormatter1.string(from: localDate)
                                enableNext = true
                            }
                        }
                    }else if question.answerType == ViewType.kDropdown.rawValue {
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as!  DropdownAnswerCell
                        if let text = cell.labelSelected.text?.trimmingCharacters(in: .whitespaces), text != "Select"{
                            let answers = question.answerArray.filter({ $0.text ==  text })
                            if answers.count > 0 {
                                let answer = answers[0]
                                userAnswer.answerFreeText = answer.text
                                userAnswer.choiceId = answer.id
                                enableNext = true
                            }
                        }
                    }
                    else if question.answerType == ViewType.kImageUpload.rawValue {
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as!  ImageAnswerCell
                        if let name =  cell.media.name , name != "" {
                            enableNext = true
                        }
                    }
                    else if question.answerType == ViewType.kAudioUpload.rawValue {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopPlaying"), object: nil)
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as! AudioAnswerCell
                        
                        if let name =  cell.media.name , name != "" {
                            enableNext = true
                        }
                    }
                    else if question.answerType == ViewType.kVideoUpload.rawValue {
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopPlaying"), object: nil)
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as!  VideoAnswerCell
                        if let name =  cell.media.name , name != "" {
                            enableNext = true
                        }
                    }
                    else if question.answerType == ViewType.kSlider.rawValue || question.answerType == "SLIDER_WITH_SCALE" {
                        let cell = questionTable.cellForRow(at: IndexPath(row: row, section: 0)) as!  SliderAnswerCell
                        if cell.seekSlider.selectedMaximum != 0{
                            userAnswer.answerFreeText = "\(Int(cell.seekSlider.selectedMaximum))"
                            enableNext = true
                        }
                    }
                    
                    if question.questionType ==  ViewType.kAudio.rawValue || question.questionType ==  ViewType.kVideo.rawValue || question.questionType ==  ViewType.kVideoUpload.rawValue || question.questionType ==  ViewType.kAudioUpload.rawValue{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopPlaying"), object: nil)
                    }
                    if !enableNext {
                        break
                    }else{
                        if userAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                          var temp = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                            temp = userAnswer
                           var temp2 =  userAnswerArray.filter({ $0.questionId == question.id })[0]
                            temp2 = userAnswer

                        }else{
                            userAnswerArray.append(userAnswer)
                        }
                        
                    }
                    var isDropDown = true

                    if question.answerArray.count > 0 {
                        for _ in question.answerArray {
                            if question.answerType == ViewType.kDropdown.rawValue {
                                if isDropDown{
                                    row += 1
                                    isDropDown = false
                                }
                            }else{
                                row += 1
                        
                            }
                        }
                    }else{
                        row += 1
                    }
            
                }
                if section.questionArray.count == 0 {
                    enableNext = true
                }
        }
            if enableNext {
                if (questionNumber + 1) < survey.pagesArray.count {
                    questionNumber = questionNumber + 1
                    self.changePage(pageid: nextPageId)
                    questionTableReloaded()
                    updateProgressBar()
                    if (questionNumber + 1) == survey.pagesArray.count {
                        let view = CustomSuccessAlert.instanceFromNib(title: "Whoa!", message: "You are only 1 answer away from completing this questionnaire.", okButtonTitle: "Ok", type: .normal) 
                        UIApplication.shared.keyWindow?.addSubview(view)
                    }
                }else{
                    var endTime = Int(Date().timeIntervalSince1970)
                    endTime  += TimeZone.current.secondsFromGMT()
                    survey.endTime = endTime * 1000
                    survey.lastSubmissionTime = endTime * 1000
                    survey.timeSpent = (survey.timeSpent ?? 0.0) + Double((survey.lastSubmissionTime ?? 1) / 1000 ) - Double((survey.startTime ?? 1) / 1000 )
                    survey.pageNavigationArray = pageNavigationArray
                    var pageNavigationJson = [[String : Any]]()
                    for page in pageNavigationArray {
                        let dict = page.getDict()
                        pageNavigationJson.append(dict)
                    }
                    survey.pageNavigationJson = pageNavigationJson
                    survey.userAnswerLogsArray = userAnswerArray
                    var userAnswerLogsJson = [[String : Any]]()
                    for page in userAnswerArray {
                        if let questionId = page.questionId , questionId != 0 {
                            let dict = page.getDict()
                            userAnswerLogsJson.append(dict)
                        }
                    }
                    survey.userAnswerLogsJson = userAnswerLogsJson
                    survey.percentageComplete = 100
                    survey.progressStatus = kCOMPLETED
                    if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
                        CustomActivityIndicator.startAnimating( message: "Submitting...")
                        submitSurvey(survey) { (success, response, message) in
                            DispatchQueue.main.async {
                                CustomActivityIndicator.stopAnimating()
                                if success{
                                    self.survey.isUploaded = 1
                                    var _ = DatabaseHandler.insertIntoSurveyData(survey: self.survey)
                                    var _ = DatabaseHandler.updateSchedule(progressStatus: self.survey.progressStatus ?? "", isDeclined: self.survey.declined ?? 0 , surveySessionId: self.survey.surveySessionId ?? 0, actualEndTime: self.survey.endTime ?? 0 , percentageCompleted : self.survey.percentageComplete ?? 0 )
                                    if self.survey.type?.lowercased() == "TRAINING".lowercased(){
                                        let congratullationController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.TrainingSuccessController) as! TrainingSuccessController
                                        var total = 0
                                        var score = 0
                                        for answer in self.userAnswerArray{
                                            total += 1
                                            if let scoreValue = answer.score , scoreValue != 0 {
                                                score += 1
                                            }
                                        }
                                        if score == 0 {
                                            congratullationController.labelDescriptionText = "Your total score is 0%"
                                        }else{
                                            congratullationController.labelDescriptionText =  String(format: "Your total score is %0.0f ", ( Float(score) / Float(total)) * 100 ) + "%"
                                        }
                                        self.navigationController?.pushViewController(congratullationController ,  animated :  true)
                                        
                                    }else{
                                        let congratullationController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.CongratullationController) as! CongratullationController
                                        self.navigationController?.pushViewController(congratullationController ,  animated :  true)
                                    }
                                }else{
                                    self.survey.isUploaded = 0
                                    var _ = DatabaseHandler.insertIntoSurveyData(survey: self.survey)
                                    var _ = DatabaseHandler.updateSchedule(progressStatus: self.survey.progressStatus ?? "", isDeclined: self.survey.declined ?? 0 , surveySessionId: self.survey.surveySessionId ?? 0 , actualEndTime: self.survey.endTime ?? 0 , percentageCompleted : self.survey.percentageComplete ?? 0 )
                                    self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                                }
                            }
                        }
                    }else{
                        self.showErrorAlert(titleString: "Offline Mode", message: "You're offline. Saving data locally on your device. Data will get synched as soon as you're back online.")
                        survey.isUploaded = 0
                        var _ = DatabaseHandler.insertIntoSurveyData(survey: self.survey)
                        var _ = DatabaseHandler.updateSchedule(progressStatus: self.survey.progressStatus ?? "", isDeclined: self.survey.declined ?? 0 , surveySessionId: self.survey.surveySessionId ?? 0 , actualEndTime: survey.endTime ?? 0 , percentageCompleted : self.survey.percentageComplete ?? 0 )
                        
                        if survey.type?.lowercased() == "TRAINING".lowercased(){
                            let congratullationController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.TrainingSuccessController) as! TrainingSuccessController
                            var total = 0
                            var score = 0
                            for answer in self.userAnswerArray{
                                total += 1
                                if let scoreValue = answer.score , scoreValue != 0 {
                                    score += 1
                                }
                            }
                            if score == 0 {
                                congratullationController.labelDescriptionText = "Your total score is 0%"
                            }else{
                                congratullationController.labelDescriptionText =  String(format: "Your total score is %0.0f ", ( Float(score) / Float(total)) * 100 ) + "%"
                            }
                            self.navigationController?.pushViewController(congratullationController ,  animated :  true)
                        }else{
                            let congratullationController = PostLoginStoryboard.instantiateViewController(withIdentifier :  AppController.CongratullationController) as! CongratullationController
                            self.navigationController?.pushViewController(congratullationController ,  animated :  true)
                        }
                    }
                }
                updateQuestionLabel()
            }else{
                let view = CustomSuccessAlert.instanceFromNib(title: "Help", message: helpText, okButtonTitle: "Ok", type: .error)  
                UIApplication.shared.keyWindow?.addSubview(view)
            }
        }
    }
    
    @IBAction func previousQuestion(_ sender: UIButton) {
        let sectionArray =  selectedPageModel.sectionArray
        if  sectionArray.count > 0 && sectionArray[0].questionArray.count > 0 {
            let question = sectionArray[0].questionArray[0]
            if question.questionType == ViewType.kAudio.rawValue || question.questionType ==  ViewType.kVideo.rawValue {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopPlaying"), object: nil)
            }
        }
        questionNumber = questionNumber - 1
        loadNewCell = true
        self.changePage(pageid: previousPageId)
        questionTableReloaded()
        updateQuestionLabel()
    }
    
    func updateProgressBar() {
        if questionProgressView.progress <= Float(questionNumber) / Float(survey.pagesArray.count) {
            
            questionProgressView.setProgress( Float(questionNumber) / Float(survey.pagesArray.count), animated: true)
            survey.percentageComplete = Double(questionProgressView.progress) * 100
        }
    }
    
    func questionTableReloaded() {
        questionTable.reloadData()
        questionTable.contentOffset = CGPoint(x: 0, y: 0)
        if let _ = questionTable.cellForRow(at: IndexPath(row: 0, section: 0) ){
            questionTable.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: true)
        }else{
            questionTable.scrollsToTop = true
        }
        if questionTable.frame.height >= questionTable.contentSize.height {
            questionTable.isScrollEnabled = false
        }else{
            questionTable.isScrollEnabled = true
        }
    }
    func getTimeLineData()  {
        WebServiceMethods.sharedInstance.getTimeline(0, toRow: 20){ (success, response, message) in
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
            }
        }
    }
    
}

//MARK:- UITableViewDataSource
extension QuestionnaireController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        var quesNumber = 0
        questionAnswerArray.removeAll()
        if selectedPageModel.sectionArray.count > section {
        let sectionArray = selectedPageModel.sectionArray[section]
            for question in sectionArray.questionArray {
                let ques = QuestionAnswer()
                ques.question = quesNumber
                ques.answer = 0
                questionAnswerArray["\(count)"] =  ques
                var isDropDown = true
                var ansNumber = 0
                if question.answerArray.count > 0 {
                    for _ in question.answerArray {
                        if question.answerType == ViewType.kDropdown.rawValue {
                            if isDropDown{
                                count += 1
                                ansNumber += 1
                                let ques = QuestionAnswer()
                                ques.question = quesNumber
                                ques.answer = ansNumber
                                questionAnswerArray["\(count)"] =  ques
                                isDropDown = false
                            }
                        }else{
                            ansNumber += 1
                            count += 1
                            let ques = QuestionAnswer()
                            ques.question = quesNumber
                            ques.answer = ansNumber
                            questionAnswerArray["\(count)"] =  ques
                        }
                    }
                }else{
                    count += 1
                    ansNumber += 1
                    let ques = QuestionAnswer()
                    ques.question = quesNumber
                    ques.answer = ansNumber
                    questionAnswerArray["\(count)"] =  ques
                }
                count += 1
                quesNumber += 1
            }
        }
        return  count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionArray =  selectedPageModel.sectionArray        
        if let quesAns = questionAnswerArray["\(indexPath.row)"] ,  sectionArray.count > indexPath.section && sectionArray[indexPath.section].questionArray.count > 0 {
            var offsetNumber = 0
            var answerOffset = 0
            var ques = 0
            if let ans = quesAns.answer , ans == 0{
                ques = quesAns.question ?? 0
                offsetNumber = 0
            }else{
                answerOffset = quesAns.answer ?? 0
                ques = quesAns.question ?? 0
                offsetNumber = 1
            }
            let question = sectionArray[indexPath.section].questionArray[ques]
            if userAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                if tempUserAnswerArray.filter({ $0.questionId == question.id }).count == 0{
                    userAnswer = userAnswerArray.filter({ $0.questionId == question.id })[0]
                    tempUserAnswerArray.append(userAnswer)
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                }else{
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                }
            }else{
                if tempUserAnswerArray.filter({ $0.questionId == question.id }).count == 0{
                    userAnswer = UserAnswerLogs()
                    userAnswer.questionId = question.id
                    tempUserAnswerArray.append(userAnswer)
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                }else{
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                }
            }
            var questionString = "Question"
            if survey.type?.lowercased() == "TRAINING".lowercased(){
                questionString = "Page"
            }else{
                if let surveyDetail = kUserDefault.value(forKey: ksurvey_detail) as? [String : Any] {
                    if let question = surveyDetail["13"] as? String {
                        questionString = question.capitalized
                    }
                }
            }
//            if let surveyDetail = kUserDefault.value(forKey: ksurvey_detail) as? [String : Any] {
//                if let question = surveyDetail["13"] as? String {
//                    questionString = question.capitalized
//                }
//            }
            
            if offsetNumber == 0{
                if question.questionType == ViewType.kAudio.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.AudioQuestionCell, for: indexPath as IndexPath)as! AudioQuestionCell
                    
                    questionString += " No.\(questionNumber + 1)"
                    
                    if selectedPageModel.sectionArray.count > 1{
                        questionString = ".\(indexPath.section)"
                    }
                    
                    if sectionArray[indexPath.section].questionArray.count > 1 {
                        questionString +=  " (\(letters[ques]))"
                    }
                    
                    cell.labelQuestionNumber.text = questionString

                    cell.helpText = question.helpText ?? ""
                    cell.selectionStyle = .none
                    cell.labelQuestion.text = question.text
                    if let url = question.url, loadNewCell{
                        cell.videoPlayerItem = nil
                        if  let mediaUrl = URL(string:url) {
                            cell.videoPlayerItem = AVPlayerItem.init(url: CommonMethods.mediaUrl(url: mediaUrl))
                            cell.setupMoviePlayer(url: CommonMethods.mediaUrl(url: mediaUrl))
                            loadNewCell = false
                        }
                    }
                    return cell
                }else if question.questionType == ViewType.kVideo.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.VideoQuestionCell, for: indexPath as IndexPath)as! VideoQuestionCell
                    
                    
                    questionString += " No.\(questionNumber + 1)"
                    
                    if selectedPageModel.sectionArray.count > 1{
                        questionString = ".\(indexPath.section)"
                    }
                    
                    if sectionArray[indexPath.section].questionArray.count > 1 {
                        questionString +=  " (\(letters[ques]))"
                    }
                    
                    cell.labelQuestionNumber.text = questionString

                    cell.helpText = question.helpText ?? ""
                    cell.selectionStyle = .none
                    cell.labelQuestion.text = question.text
                    if let url = question.url?.trimmingCharacters(in: .whitespacesAndNewlines), loadNewCell {
                        if let mediaUrl = URL(string: url.trimmingCharacters(in: .whitespacesAndNewlines)) {
                            cell.videoPlayerItem = nil
                            cell.videoPlayerItem = AVPlayerItem.init(url: CommonMethods.mediaUrl(url: mediaUrl))
                            cell.setupMoviePlayer(url: CommonMethods.mediaUrl(url: mediaUrl))
                            loadNewCell = false
                        }
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.QuestionCell, for: indexPath as IndexPath) as! QuestionCell
                    cell.helpText = question.helpText ?? ""
                    
                    questionString += " No.\(questionNumber + 1)"
                    
                    if selectedPageModel.sectionArray.count > 1{
                        questionString = ".\(indexPath.section)"
                    }
                    
                    if sectionArray[indexPath.section].questionArray.count > 1 {
                        questionString +=  " (\(letters[ques]))"
                    }
                    
                    cell.labelQuestionNumber.text = questionString

                    cell.selectionStyle = .none
                    cell.labelQuestion.text = question.text
                    return cell
                }
            }else{
                //Answer Cell
                let answerArray = question.answerArray
                var media = MediaModel()
                
                if let mediaModel = DatabaseHandler.getMedia(survey.surveySessionId ?? 0, questionId: question.id  ?? 0) , let _ = mediaModel.name {
                    media = mediaModel
                }else if let mediaModel = DatabaseHandler.getMedia(userAnswer.id ?? 0, questionId: question.id  ?? 0) , let _ = mediaModel.name {
                    media = mediaModel

                }else{
                    media = MediaModel()
                    media.sessionScheduleId = survey.surveySessionId
                    media.questionId = question.id
                    media.pageId = selectedPageModel.id
                    media.endTime = survey.scheduledEndTime
                }
                if answerArray.count >= (answerOffset - 1) {
                    if question.answerType == ViewType.kRadio.rawValue {
                      let answer = answerArray[answerOffset - 1]
                        if let url = answer.url?.trimmingCharacters(in: .whitespacesAndNewlines)  , url != "" ,  let mediaUrl = URL(string:url)  {
                            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.ImageDropdownCell, for: indexPath as IndexPath) as! ImageDropdownCell
                            cell.selectionStyle = .none
                            cell.delegate = self
                            cell.answer = answer
                            cell.tag = indexPath.row
                            if userAnswer.choiceId == answer.id {
                                cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOn")
                                cell.backGroundImage.layer.borderColor = UIColor.appButtonColor.cgColor
                                cell.backGroundImage.layer.borderWidth = 2.0
                                cell.backGroundImage.layer.cornerRadius = 2
                                cell.backGroundImage.clipsToBounds = true
                            }else{
                                cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOff")
                                cell.backGroundImage.layer.borderColor = UIColor.clear.cgColor
                                cell.backGroundImage.layer.borderWidth = 2.0
                                cell.backGroundImage.layer.cornerRadius = 2
                                cell.backGroundImage.clipsToBounds = true
                            }
                            if let image = UIImage(contentsOfFile:  CommonMethods.mediaUrl(url: mediaUrl).path) {
                                cell.imgageOption.image = image
                                    if !self.imageDropDownArray.contains(indexPath.row){
                                        self.imageDropDownArray.append(indexPath.row)
                                        var rect = cell.imgageOption.frame
                                        rect.size.height = (rect.size.width / image.size.width )  *  image.size.height
                                        cell.imgageOption.frame = rect
                                        cell.optionImageHeightConstant.constant = rect.size.height
                                    }
                            }else{
                                cell.imgageOption.sd_setImage(with: CommonMethods.mediaUrl(url: mediaUrl)) { (image, error, SDImageCacheTypeDisk, url1) in
                                    DispatchQueue.main.async {
                                        if !self.imageDropDownArray.contains(indexPath.row){
                                            if let option = image{
                                                self.imageDropDownArray.append(indexPath.row)
                                                
                                                var rect = cell.imgageOption.frame
                                                rect.size.height = (rect.size.width / option.size.width )  *  option.size.height
                                                cell.imgageOption.frame = rect
                                                cell.optionImageHeightConstant.constant = rect.size.height
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            cell.radioButton.tag = indexPath.row
                            return cell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.RadioAnswerCell, for: indexPath as IndexPath) as! RadioAnswerCell
                            cell.delegate = self
                            cell.answer = answer
                            cell.tag = indexPath.row
                            cell.selectionStyle = .none
                            if userAnswer.choiceId == answer.id {
                                cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOn")
                            }else{
                                cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOff")
                            }
                            cell.labelQuestion.text = answer.text
                            cell.radioButton.tag = indexPath.row
                            return cell
                        }
                    }
                }
                if answerArray.count >= (answerOffset - 1){
                    if question.answerType == ViewType.kCheck.rawValue {
                        let answer = answerArray[answerOffset - 1]
                        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.QuestionCheckBoxCell, for: indexPath as IndexPath) as! QuestionCheckBoxCell
                        cell.selectionStyle = .none
                        cell.delegate = self
                        cell.answer = answer
                        cell.tag = indexPath.row
                        let ansArray = userAnswer.answerFreeText?.components(separatedBy: ",")
                        if let _ = ansArray?.index(of: "\(answer.id ?? 0)")  {
                            cell.checkImage.image = #imageLiteral(resourceName: "tickOptionOn")
                        }else{
                            cell.checkImage.image = #imageLiteral(resourceName: "tickOptionOff")
                        }
                        cell.labelQuestion.text = answer.text
                        return cell
                    }
                }
                if question.answerType == ViewType.kTextbox.rawValue ||  question.answerType == ViewType.kNumeric.rawValue{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TextAnswerCell, for: indexPath as IndexPath) as! TextAnswerCell
                    cell.selectionStyle = .none
                    cell.answerTextfield.placeholder = "Enter"
                    if  question.answerType == ViewType.kNumeric.rawValue {
                        cell.answerTextfield.keyboardType = .numberPad

                    }else{
                        cell.answerTextfield.keyboardType = .default

                    }

                    if let text = userAnswer.answerFreeText{
                        cell.answerTextfield?.text = text
                    }else{
                        cell.answerTextfield?.text = ""
                    }
                    return cell
                }else if question.answerType == ViewType.kBP.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.BPAnswerCell, for: indexPath as IndexPath) as! BPAnswerCell
                    cell.selectionStyle = .none
                    if let text = userAnswer.answerFreeText{
                        let bp = text.components(separatedBy: "/")
                        if bp.count == 2{
                            cell.systolicTextfield?.text = bp[0]
                            cell.diastolicTextfield?.text = bp[1]
                        }else if bp.count == 1{
                            cell.systolicTextfield?.text = bp[0]
                            cell.diastolicTextfield?.text = ""
                        }else{
                            cell.systolicTextfield?.text = ""
                            cell.diastolicTextfield?.text = ""
                        }
                    }else{
                        cell.systolicTextfield?.text = ""
                        cell.diastolicTextfield?.text = ""
                    }
                    return cell
                }
                else if question.answerType == ViewType.kDate.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DateAnswerCell, for: indexPath as IndexPath) as! DateAnswerCell
                    cell.selectionStyle = .none
                    if let text = userAnswer.answerFreeText?.trimmingCharacters(in: .whitespacesAndNewlines) , text != "" {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        if let localDate = dateFormatter.date(from: text) {
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "MMMM dd, yyyy"
                            dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
                            cell.labelDate?.text = dateFormatter1.string(from: localDate)
                        }else{
                            cell.labelDate?.text = "Select Date"
                        }
                    }else{
                        cell.labelDate?.text = "Select Date"
                    }
                    return cell
                }else if question.answerType == ViewType.kRating.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.RatingAnswerCell, for: indexPath as IndexPath) as! RatingAnswerCell
                    if let rating = userAnswer.answerFreeText {
                        cell.ratingView.rating = Double(rating ) ?? 0
                    }else{
                        cell.ratingView.rating = 0
                    }
                    cell.selectionStyle = .none
                    return cell
                }else if question.answerType == ViewType.kRichtext.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TextViewAnswerCell, for: indexPath as IndexPath) as! TextViewAnswerCell
                    if let text = userAnswer.answerFreeText {
                        cell.richTextView.text = text
                    }else{
                        cell.richTextView.text = "Enter text"
                    }
                    cell.selectionStyle = .none
                    return cell
                }else if question.answerType == ViewType.kAge.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TextAnswerCell, for: indexPath as IndexPath) as! TextAnswerCell
                    cell.answerTextfield.delegate = self
                    cell.answerTextfield.keyboardType = .numberPad
                    cell.answerTextfield.placeholder = "Enter age(in years)"
                    if let text = userAnswer.answerFreeText {
                        cell.answerTextfield.text = text
                    }else{
                        cell.answerTextfield.text = ""
                    }
                    cell.selectionStyle = .none
                    return cell
                }else if question.answerType == ViewType.kTime.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TimeAnswerCell, for: indexPath as IndexPath) as! TimeAnswerCell
                 
                    cell.selectionStyle = .none
                    if let text = userAnswer.answerFreeText?.trimmingCharacters(in: .whitespacesAndNewlines) , text != "" {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        if  let localDate = dateFormatter.date(from: text) {
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "hh:mm a"
                          //  dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
                            cell.labelTime?.text = dateFormatter1.string(from: localDate)
                        }else{
                            cell.labelTime?.text = "Select time"
                        }
                    }else{
                        cell.labelTime.text = "Select time"
                    }
                    return cell
                }else if question.answerType == ViewType.kDropdown.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DropdownAnswerCell, for: indexPath as IndexPath) as! DropdownAnswerCell
                    cell.dataForDropdown(data: question.answerArray.compactMap({ $0.text }))
                    if let choiceId = userAnswer.choiceId {
                        let answers = question.answerArray.filter({ $0.id ==  choiceId })
                        if answers.count > 0 {
                            let answer = answers[0]
                            cell.labelSelected.text = answer.text
                        }else{
                            cell.labelSelected.text = "Select"
                        }
                    }else{
                        cell.labelSelected.text = "Select"
                    }
                    cell.selectionStyle = .none
                    return cell
                }else if question.answerType == ViewType.kImageUpload.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.ImageAnswerCell, for: indexPath as IndexPath) as! ImageAnswerCell
                    cell.selectionStyle = .none
                    cell.media = media
                    cell.configureCell()
                    return cell
                }else if question.answerType == ViewType.kAudioUpload.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.AudioAnswerCell, for: indexPath as IndexPath) as! AudioAnswerCell
                    cell.selectionStyle = .none
                    cell.media = media
                    cell.configureCell()
                    return cell
                }
                else if question.answerType == ViewType.kVideoUpload.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.VideoAnswerCell, for: indexPath as IndexPath) as! VideoAnswerCell
                    cell.selectionStyle = .none
                    cell.media = media
                    cell.configureCell()
                    return cell
                }
                else if question.answerType == ViewType.kSlider.rawValue || question.answerType == "SLIDER_WITH_SCALE" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.SliderAnswerCell, for: indexPath as IndexPath) as! SliderAnswerCell
                    if let rating = userAnswer.answerFreeText {
                        cell.seekSlider.selectedMaximum = Float(rating) ?? 0
                    }else{
                        cell.seekSlider.selectedMaximum  = 0
                    }
                    cell.selectionStyle = .none
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.QuestionCell, for: indexPath as IndexPath) as! QuestionCell
                    cell.labelQuestion.text = question.text
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.QuestionCell, for: indexPath as IndexPath) as! QuestionCell
        cell.selectionStyle = .none
        return cell

    }
}

//MARK:- UITableViewDelegate

extension QuestionnaireController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sectionArray =  selectedPageModel.sectionArray
        if let quesAns = questionAnswerArray["\(indexPath.row)"] ,  sectionArray.count > indexPath.section && sectionArray[indexPath.section].questionArray.count > 0 {
            var offsetNumber = 0
            var ques = 0
            if let ans = quesAns.answer , ans == 0{
                ques = quesAns.question ?? 0
                offsetNumber = 0
            }else{
               // answerOffset = quesAns.answer ?? 0
                ques = quesAns.question ?? 0
                offsetNumber = 1
            }
            let question = sectionArray[indexPath.section].questionArray[ques]
            if offsetNumber != 0{
                if question.answerType != ViewType.kCheck.rawValue && question.answerType != ViewType.kRadio.rawValue {
                    
                    //return UIScreen.main.bounds.size.width
                }else{
                    return UITableView.automaticDimension
                    
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.0001
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedPageModel.sectionArray.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedPageModel.sectionArray.count > section {
            let questionSsection = selectedPageModel.sectionArray[section]
            if let text = questionSsection.text?.trimmingCharacters(in: .whitespacesAndNewlines) , text != ""{
                
                if text.lowercased().contains("<div".lowercased()){
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.WebViewCell)  as? WebViewCell
                    if let height = tableSectionArray[section]{
                      //  cell?.webViewHeightConstraint.constant = height
                    }
                    cell?.cellIndexpath = section
                    cell?.delegate = self
                    cell?.htmlContent = text
                    if let _ = tableSectionArray[section]{
                        cell?.loadCss = false
                   }
                    cell?.configure()

                    cell?.selectionStyle = .none
                    return cell!
                }else{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermSingleTextCell)  as? TermSingleTextCell
                    cell?.labelDetail.text = text
                    cell?.selectionStyle = .none
                    return cell!
                }
                
            }
            if let urlType = questionSsection.mediaType?.trimmingCharacters(in: .whitespacesAndNewlines) , urlType != ""{
                
                if urlType.lowercased() == kImage.lowercased() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermImageCell)  as? TermImageCell
                    cell?.selectionStyle = .none
                    return cell!
                }else if urlType.lowercased() == kAudio.lowercased() {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermAudioCell)  as? TermAudioCell
                    cell?.selectionStyle = .none
                    return cell!
                }else if urlType.lowercased() == kVideo.lowercased() && urlType.lowercased().contains("www.youtube.com") {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermWebCell)  as? TermWebCell
                  //  cell?.labelTitle.text = statement.header
                  //  cell?.labelDetail.text = statement.descriptions
                    cell?.webUrl = urlType
                    cell?.selectionStyle = .none
                    return cell!
                }else if  urlType.lowercased() == kVideo.lowercased() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermVideoCell)  as? TermVideoCell
                    cell?.selectionStyle = .none
                    return cell!
                }else{
                    return UIView()
                }
            }else  {
                return UIView()

            }
        }else{
            return UIView()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if let height = tableSectionArray[section]{
            return height
            
        }
        if selectedPageModel.sectionArray.count > section {
            let section = selectedPageModel.sectionArray[section]
            if let text = section.text?.trimmingCharacters(in: .whitespacesAndNewlines) , text != ""{
                return UITableView.automaticDimension
            }
            if let text = section.mediaType?.trimmingCharacters(in: .whitespacesAndNewlines) , text != ""{
                return UITableView.automaticDimension
            }
        }
       return 0.0001
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let height = tableSectionArray[section]{
            return height
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

}

//MARK:- UITextFieldDelegate

extension QuestionnaireController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let sectionArray =  selectedPageModel.sectionArray
        if sectionArray.count > 0 && sectionArray[0].questionArray.count > 0 {
            let question = sectionArray[0].questionArray[0]
            if question.answerType == ViewType.kAge.rawValue {
                let currentCharacterCount = textField.text?.count ?? 0
                if (range.length + range.location > currentCharacterCount){
                    return false
                }
                let newLength = currentCharacterCount + string.count - range.length
                return newLength <= 2
            }else if question.answerType == ViewType.kBP.rawValue {
                let currentCharacterCount = textField.text?.count ?? 0
                if (range.length + range.location > currentCharacterCount){
                    return false
                }
                let newLength = currentCharacterCount + string.count - range.length
                return newLength <= 3
            }
        }
        return true
    }
    
    
}

//MARK:- CustomWarningAlertDelegate

extension QuestionnaireController : CustomWarningAlertDelegate {
    func clickOnOKButton(_ sender: CustomWarningAlert) {
        if let retake = survey.retakeAllowed , retake == 0 {
           expireSurvey()
        }else{
            if let autoSave = survey.autoSave , autoSave == 0 {
                resetSurvey()
            }else{
                saveSurvey()
            }
        }
    }
}

//MARK:- RadioAnswerCellDelegate

extension QuestionnaireController : RadioAnswerCellDelegate{

    func rowSelected(answer: AnswersModel, cell: RadioAnswerCell) {
        guard let indexPath = questionTable.indexPath(for: cell) else {
            return
        }

        let sectionArray =  selectedPageModel.sectionArray
        if let quesAns = questionAnswerArray["\(indexPath.row)"] ,  sectionArray.count > indexPath.section && sectionArray[indexPath.section].questionArray.count > 0 {
            var answerOffset = 0
            var ques = 0
            if let ans = quesAns.answer , ans == 0{
                ques = quesAns.question ?? 0
                return
            }else{
                answerOffset = quesAns.answer ?? 0
                ques = quesAns.question ?? 0
            }
            let question = sectionArray[indexPath.section].questionArray[ques]
            if userAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                if tempUserAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                }else{
                    userAnswer = userAnswerArray.filter({ $0.questionId == question.id })[0]
                    tempUserAnswerArray.append(userAnswer)
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                }
            }else{
                if tempUserAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                }else{
                    userAnswer.questionId = question.id
                    tempUserAnswerArray.append(userAnswer)
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                }
            }
            
            if question.answerType == ViewType.kRadio.rawValue {
                userAnswer.choiceId = question.answerArray[answerOffset - 1].id
                userAnswer.score = question.answerArray[answerOffset - 1].score

                for i in (indexPath.row - answerOffset + 1)...(indexPath.row - answerOffset + question.answerArray.count ) {
                    if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? RadioAnswerCell {
                        if userAnswer.choiceId == question.answerArray[ i - (indexPath.row - answerOffset + 1 )].id {
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOn")
                        }else{
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOff")
                        }
                    }else if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? ImageDropdownCell {
                        if userAnswer.choiceId == question.answerArray[ i - (indexPath.row - answerOffset + 1 )].id {
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOn")
                            cell.backGroundImage.layer.borderColor = UIColor.appButtonColor.cgColor
                            cell.backGroundImage.layer.borderWidth = 2.0
                            cell.backGroundImage.layer.cornerRadius = 2
                            cell.backGroundImage.clipsToBounds = true
                        }else{
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOff")
                            cell.backGroundImage.layer.borderColor = UIColor.clear.cgColor
                            cell.backGroundImage.layer.borderWidth = 2.0
                            cell.backGroundImage.layer.cornerRadius = 2
                            cell.backGroundImage.clipsToBounds = true
                        }
                    }
                }
            }else if question.answerType == ViewType.kCheck.rawValue {
                userAnswer.choiceId = question.answerArray[answerOffset - 1].id
                userAnswer.score = question.answerArray[answerOffset - 1].score

                if  let cell1 = questionTable.cellForRow(at: indexPath) as? QuestionCheckBoxCell {

                    let ansArray = userAnswer.answerFreeText?.components(separatedBy: ",")
                    //userAnswer.answerFreeText , text != "", text.contains(answer.id ?? "")
                    if let _ = ansArray?.index(of: "\(question.answerArray[answerOffset - 1].id ?? 0)")  {
                        cell1.checkImage.image = #imageLiteral(resourceName: "tickOptionOff")
                    }else{
                        cell1.checkImage.image = #imageLiteral(resourceName: "tickOptionOn")

                    }
                }
                var values = [String]()
                for i in (indexPath.row - answerOffset + 1)...(indexPath.row - answerOffset + question.answerArray.count ) {
                    if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? QuestionCheckBoxCell {
                        if  cell.checkImage.image == #imageLiteral(resourceName: "tickOptionOn") {
                            values.append("\(question.answerArray[i - 1].id ?? 0)")
                        }
                    }
                }
                userAnswer.answerFreeText = values.joined(separator: ",")
            }
        }
    }
}

//MARK:- ImageDropdownCellDelegate

extension QuestionnaireController : ImageDropdownCellDelegate{
    
    
    func imageSelected(answer: AnswersModel, cell: ImageDropdownCell) {
        guard let indexPath = questionTable.indexPath(for: cell) else {
            return
        }
        
        let sectionArray =  selectedPageModel.sectionArray
        if let quesAns = questionAnswerArray["\(indexPath.row)"] ,  sectionArray.count > indexPath.section && sectionArray[indexPath.section].questionArray.count > 0 {
            var answerOffset = 0
            var ques = 0
            if let ans = quesAns.answer , ans == 0{
                ques = quesAns.question ?? 0
                return
            }else{
                answerOffset = quesAns.answer ?? 0
                ques = quesAns.question ?? 0
            }
            let question = sectionArray[indexPath.section].questionArray[ques]
            if userAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                if tempUserAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                    
                }else{
                    userAnswer = userAnswerArray.filter({ $0.questionId == question.id })[0]
                    tempUserAnswerArray.append(userAnswer)
                }
                
            }else{
                if tempUserAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                    
                }else{
                    userAnswer.questionId = question.id
                    userAnswerArray.append(userAnswer)
                    userAnswer = userAnswerArray.filter({ $0.questionId == question.id })[0]
                }
                
            }
            
            if question.answerType == ViewType.kRadio.rawValue {
                userAnswer.choiceId = question.answerArray[answerOffset - 1].id
                userAnswer.score = question.answerArray[answerOffset - 1].score
                for i in (indexPath.row - answerOffset + 1)...(indexPath.row - answerOffset + question.answerArray.count ) {
                    if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? RadioAnswerCell {
                        if userAnswer.choiceId == question.answerArray[ i - (indexPath.row - answerOffset + 1 )].id {
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOn")
                        }else{
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOff")
                        }
                    }else if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? ImageDropdownCell {
                        if userAnswer.choiceId == question.answerArray[ i - (indexPath.row - answerOffset + 1 )].id {
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOn")
                            cell.backGroundImage.layer.borderColor = UIColor.appButtonColor.cgColor
                            cell.backGroundImage.layer.borderWidth = 2.0
                            cell.backGroundImage.layer.cornerRadius = 2
                            cell.backGroundImage.clipsToBounds = true
                        }else{
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOff")
                            cell.backGroundImage.layer.borderColor = UIColor.clear.cgColor
                            cell.backGroundImage.layer.borderWidth = 2.0
                            cell.backGroundImage.layer.cornerRadius = 2
                            cell.backGroundImage.clipsToBounds = true
                        }
                    }
                }
            }else  if question.answerType == ViewType.kCheck.rawValue {
                userAnswer.choiceId = question.answerArray[answerOffset - 1].id
                
                if  let cell1 = questionTable.cellForRow(at: indexPath) as? QuestionCheckBoxCell {
                    let ansArray = userAnswer.answerFreeText?.components(separatedBy: ",")
                    if let _ = ansArray?.index(of: "\(question.answerArray[answerOffset - 1].id ?? 0)")  {
                        cell1.checkImage.image = #imageLiteral(resourceName: "tickOptionOff")
                    }else{
                        cell1.checkImage.image = #imageLiteral(resourceName: "tickOptionOn")
                        
                    }
                }
                var values = [String]()
                for i in (indexPath.row - answerOffset + 1)...(indexPath.row - answerOffset + question.answerArray.count ) {
                    if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? QuestionCheckBoxCell {
                        if  cell.checkImage.image == #imageLiteral(resourceName: "tickOptionOn") {
                            values.append("\(question.answerArray[i - 1].id ?? 0)")
                        }
                    }
                }
                userAnswer.answerFreeText = values.joined(separator: ",")
            }
        }
    }
}

//MARK:- QuestionCheckBoxCellDelegate

extension QuestionnaireController : QuestionCheckBoxCellDelegate{
 
    func checkBoxSelected(answer: AnswersModel, cell: QuestionCheckBoxCell) {
        guard let indexPath = questionTable.indexPath(for: cell) else {
            return
        }
        
        let sectionArray =  selectedPageModel.sectionArray
        if let quesAns = questionAnswerArray["\(indexPath.row)"] ,  sectionArray.count > indexPath.section && sectionArray[indexPath.section].questionArray.count > 0 {
            var answerOffset = 0
            var ques = 0
            if let ans = quesAns.answer , ans == 0{
                ques = quesAns.question ?? 0
                return
            }else{
                answerOffset = quesAns.answer ?? 0
                ques = quesAns.question ?? 0
            }
            let question = sectionArray[indexPath.section].questionArray[ques]
            if userAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                if tempUserAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                    
                }else{
                    userAnswer = userAnswerArray.filter({ $0.questionId == question.id })[0]
                    tempUserAnswerArray.append(userAnswer)
                }
                
            }else{
                if tempUserAnswerArray.filter({ $0.questionId == question.id }).count > 0 {
                    userAnswer = tempUserAnswerArray.filter({ $0.questionId == question.id })[0]
                    
                }else{
                    userAnswer.questionId = question.id
                    userAnswerArray.append(userAnswer)
                    userAnswer = userAnswerArray.filter({ $0.questionId == question.id })[0]
                }
                
            }
            
            if question.answerType == ViewType.kRadio.rawValue {
                userAnswer.choiceId = question.answerArray[answerOffset - 1].id
                for i in (indexPath.row - answerOffset + 1)...(indexPath.row - answerOffset + question.answerArray.count ) {
                    if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? RadioAnswerCell {
                        if userAnswer.choiceId == question.answerArray[ i - (indexPath.row - answerOffset + 1 )].id {
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOn")
                        }else{
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOff")
                        }
                    }else if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? ImageDropdownCell {
                        if userAnswer.choiceId == question.answerArray[ i - (indexPath.row - answerOffset + 1 )].id {
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOn")
                            cell.backGroundImage.layer.borderColor = UIColor.appButtonColor.cgColor
                            cell.backGroundImage.layer.borderWidth = 2.0
                            cell.backGroundImage.layer.cornerRadius = 2
                            cell.backGroundImage.clipsToBounds = true
                        }else{
                            cell.radioImage?.image = #imageLiteral(resourceName: "radioOptionOff")
                            cell.backGroundImage.layer.borderColor = UIColor.clear.cgColor
                            cell.backGroundImage.layer.borderWidth = 2.0
                            cell.backGroundImage.layer.cornerRadius = 2
                            cell.backGroundImage.clipsToBounds = true
                        }
                    }
                }
            }else  if question.answerType == ViewType.kCheck.rawValue {
                userAnswer.choiceId = question.answerArray[answerOffset - 1].id
                
                if  let cell1 = questionTable.cellForRow(at: indexPath) as? QuestionCheckBoxCell {
                    let ansArray = userAnswer.answerFreeText?.components(separatedBy: ",")
                    if let _ = ansArray?.index(of: "\(question.answerArray[answerOffset - 1].id ?? 0)")  {
                        cell1.checkImage.image = #imageLiteral(resourceName: "tickOptionOff")
                    }else{
                        cell1.checkImage.image = #imageLiteral(resourceName: "tickOptionOn")
                    }
                }
                var values = [String]()
                for i in (indexPath.row - answerOffset + 1)...(indexPath.row - answerOffset + question.answerArray.count ) {
                    if  let cell = questionTable.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? QuestionCheckBoxCell {
                        if  cell.checkImage.image == #imageLiteral(resourceName: "tickOptionOn") {
                            values.append("\(question.answerArray[i - 1].id ?? 0)")
                        }
                    }
                }
                userAnswer.answerFreeText = values.joined(separator: ",")
            }
        }
    }
}

//MARK:- WebViewCellDelegate

extension QuestionnaireController : WebViewCellDelegate {

    func heightChange(cell: WebViewCell  ,  height : CGFloat) {
        if let section =  cell.cellIndexpath{
            cell.webView.frame = cell.backView.bounds
            var rect = cell.webView.frame
            rect.size.height = height //cell.webViewHeightConstraint.constant
            cell.webView.frame = rect
            cell.backView.bounds = rect
            cell.layoutSubviews()
            if let _ = tableSectionArray[section]{
                
            }else{
                tableSectionArray[section] = height//cell.webViewHeightConstraint.constant
                questionTable.reloadData()
                //questionTable.reloadSections([section], with: .none)
            }
        }
    }
}

