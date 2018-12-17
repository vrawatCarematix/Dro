
import Foundation
import UIKit
import LGSideMenuController

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}
enum AppStoryboard : String {
    case Main, PostLogin, Timeline
    
    var instance : UIStoryboard {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIStoryboard(name: self.rawValue + "Ipad", bundle: Bundle.main)
        }else{
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
        }
    }
}
enum ViewType : String {
    case kRadio = "RADIO_BUTTON"
    case kGenral = "GENERAL"
    case kVideo = "VIDEO"
    case kAudio = "AUDIO"
    case kTextbox = "TEXT_BOX"
    case kDate = "DATE"
    case kRating = "RATING"
    case kRichtext = "RICH_TEXT"
    case kTime = "TIME"
    case kDropdown = "DROP_DOWN"
    case kCheck = "CHECK_BOX"
    case kSlider = "SLIDER"
    case kAge = "AGE"
    case kNumeric = "NUMERIC"
    case kImageUpload = "IMAGE_UPLOAD"
    case kVideoUpload = "VIDEO_UPLOAD"
    case kAudioUpload = "AUDIO_UPLOAD"
    case kBP = "BP"
    
    
    case kMultiImage = "MULTI_IMAGE"
    case kMultiSelect = "MULTI_SELECT"
    case kSingleImage = "SINGLE_IMAGE"
    case kSliderWithoutScale = "SLIDER_WITHOUT_SCALE"
    case kSliderWithScale = "SLIDER_WITH_SCALE"
    
}




enum AlertType {
    case error
    case normal
}

let MainStoryboard = AppStoryboard.Main.instance
let PostLoginStoryboard = AppStoryboard.PostLogin.instance

struct AppController{
    static let SplashScreen = "SplashScreen"
    static let WelcomeScreen = "WelcomeScreen"
    static let SignInController = "SignInController"
    static let ForgotPassword = "ForgotPassword"
    static let ResetPassword = "ResetPassword"
    static let SuccessChangePassword = "SuccessChangePassword"
    static let DroTabBarController = "DroTabBarController"
    static let ChangePassword = "ChangePassword"
    static let ScheduleController = "ScheduleController"
    static let ViewDroController = "ViewDroController"
    static let DashboardController = "DashboardController"
    static let MessageController = "MessageController"
    static let StudyController = "StudyController"
    static let LeftViewController = "LeftViewController"
    static let EditWeightReadingController = "EditWeightReadingController"
    static let OTPScreen = "OTPScreen"
    static let CreatePassword = "CreatePassword"
    static let ChangeEmailController = "ChangeEmailController"
    static let DeleteAccountController = "DeleteAccountController"
    static let FilterDroController = "FilterDroController"
    static let FilterMessageController = "FilterMessageController"
    static let DetailTermViewController = "DetailTermViewController"
    static let TermsController = "TermsController"
    static let ProfileViewController = "ProfileViewController"
    static let EditProfileController = "EditProfileController"
    static let QutionnaireController = "QutionnaireController"
    static let DroHomeController = "DroHomeController"
    static let DeclineController = "DeclineController"
    static let DetailMessageController = "DetailMessageController"
    static let CongratullationController = "CongratullationController"
    static let LegalStatementController = "LegalStatementController"
    static let TrainingSuccessController = "TrainingSuccessController"

}


struct AppURL{
     static let domain = "http://104.209.168.184"
    static let languageJson = domain + "/droweb/assets/data/config_"

    static let baseURL =  domain + ":3000/dro/"
    //  static let signIn = baseURL + "auth/inter"
   // static let baseURL = "http://dev.carematix.com:3000/dro/"
    // test
    static let signIn = baseURL + "auth/mobile/login"
    
    static let resetPassword = baseURL + "reset-password"
    static let getMessage = baseURL + "user/message/"
    static let updateMessage = baseURL + "user/message/update"
    static let getTimeline = baseURL + "user/userTimeline"
    
    static let getAllSurvey = baseURL + "user/survey/getAllSurvey"
    static let getSurvey = baseURL + "user/survey/getSurvey"
    static let verifyOtp = baseURL + "reset-password/verify?"
    static let reset = baseURL + "reset-password/reset"
    static let getUserSurveySession = baseURL + "user/survey/getUserSurveySession"
    static let updateSurveyResponse = baseURL + "user/survey/updateSurveyResponse"
    static let dashboardData = baseURL + "user/dashboardData"
    static let profileData = baseURL + "user/personaldetails"
    static let saveProfileData = baseURL + "user/personnel-setitngs"
    
    static let calendarSchedulesNew = baseURL + "user/survey/calendarSchedulesNew"
    static let uploadFile = baseURL + "user/survey/uploadFile"
    static let viewDro = baseURL + "user/droData"
    static let changePassword = baseURL + "user/changePassword"
    
    static let configData = baseURL + "organization/"
    static let logout = baseURL + "auth/logout/"
    static let languageData = baseURL + "organization/"
    static let declineReason = baseURL + "declinereason/EN"
    static let surveyDecline = baseURL + "user/survey/decline"
    static let getFile = baseURL + "user/survey/getFile/"
    static let getCss = domain + "/droweb/assets/css/training_module.css"

}

struct ReusableIdentifier{
    static let DashboardHeaderCell  = "DashboardHeaderCell"
    static let DashboardDueTodayCell  = "DashboardDueTodayCell"
    static let DashboardUpcomingCell  = "DashboardUpcomingCell"
    static let DashboardTimelineCell  = "DashboardTimelineCell"
    static let DashboardStatisticsCell  = "DashboardStatisticsCell"

    static let DueTodayRowCell  = "DueTodayRowCell"
    static let DueTodayHeaderCell  = "DueTodayHeaderCell"
    static let UpcomingHeaderCell  = "UpcomingHeaderCell"
    static let UpcomingRowCell  = "UpcomingRowCell"
    static let TimelineHeader  = "TimelineHeader"

    static let TimelineHeaderCell  = "TimelineHeaderCell"
    static let TimelineRowCell  = "TimelineRowCell"
    static let ScheduleRowCell  = "ScheduleRowCell"
    static let ScheduleHeaderCell  = "ScheduleHeaderCell"
    static let MessageTableCell  = "MessageTableCell"
    static let ViewDroRowCell  = "ViewDroRowCell"
    static let ViewDroHeaderCell  = "ViewDroHeaderCell"
    static let ViewDroCollectionViewCell  = "ViewDroCollectionViewCell"
    static let ViewDroListCell  = "ViewDroListCell"
    static let StudyTableCell  = "StudyTableCell"
    static let StudyTableReadLessCell  = "StudyTableReadLessCell"

    static let MenuCell  = "MenuCell"
    static let SelectPersonCell  = "SelectPersonCell"
    static let landscapeGraphCell1  = "landscapeGraphCell1"
    static let landscapeGraphCell2  = "landscapeGraphCell2"
    static let landscapeGraphCell3  = "landscapeGraphCell3"
    static let landscapeGraphCell4  = "landscapeGraphCell4"
    static let LandscapeGraphCell5  = "LandscapeGraphCell5"
    static let AssociativeDeviceTableCell  = "AssociativeDeviceTableCell"
    static let InsturctionDetailCell  = "InsturctionDetailCell"

    static let DroDetailCell  = "DroDetailCell"
    static let DeclineCell  = "DeclineCell"
    static let LanguageCell  = "LanguageCell"
    static let TermsCell  = "TermsCell"
    static let LegalStatementCell  = "LegalStatementCell"

    static let TermTextCell  = "TermTextCell"
    static let DisclaimerHeaderCell  = "DisclaimerHeaderCell"

    static let TermVideoCell  = "TermVideoCell"
    static let TermWebCell  = "TermWebCell"
    static let TermSingleTextCell  = "TermSingleTextCell"
    static let WebViewCell  = "WebViewCell"

    static let TermAudioCell  = "TermAudioCell"
    static let TermImageCell  = "TermImageCell"
    static let ProfileTableViewCell  = "ProfileTableViewCell"
    static let EditProfileNameCell  = "EditProfileNameCell"
    static let EditProfileTextCell  = "EditProfileTextCell"
    static let EditProfileDropdownCell  = "EditProfileDropdownCell"
    static let DropdownSingleSelectionCell  = "DropdownSingleSelectionCell"
    static let DropdownMultiSelectionCell  = "DropdownMultiSelectionCell"

    static let EditProfileDateCell  = "EditProfileDateCell"
    static let EditProfileTextViewCell  = "EditProfileTextViewCell"
    static let QuestionCell  = "QuestionCell"
    static let RatingAnswerCell  = "RatingAnswerCell"
    static let VideoQuestionCell  = "VideoQuestionCell"
    static let AudioQuestionCell  = "AudioQuestionCell"
    static let RadioAnswerCell  = "RadioAnswerCell"
    static let ImageDropdownCell  = "ImageDropdownCell"

    static let TextAnswerCell  = "TextAnswerCell"
    static let DateAnswerCell  = "DateAnswerCell"
    static let TextViewAnswerCell  = "TextViewAnswerCell"
    static let TimeAnswerCell  = "TimeAnswerCell"
    static let DropdownAnswerCell  = "DropdownAnswerCell"
    static let ImageAnswerCell  = "ImageAnswerCell"
    static let SliderAnswerCell  = "SliderAnswerCell"
    static let VideoAnswerCell  = "VideoAnswerCell"
    static let AudioAnswerCell  = "AudioAnswerCell"
    static let DetailMessageCell  = "DetailMessageCell"
    static let BPAnswerCell  = "BPAnswerCell"
    static let QuestionCheckBoxCell  = "QuestionCheckBoxCell"

}

struct AppConstantString{
    static let appName  = "DRO"
    static let kOk  = "Ok"
    static let klogin  = "loggedIn"
    static let kYes  = "yes"
    static let kNo  = "no"
    static let kLanguageCode  = "languageCode"
    static let kLanguageName  = "languageName"
    static let kProgramUserId  = "programUserId"
    static let kUserId  = "userId"
    static let kToken  = "token"
    static let kOrganizationId  = "organizationId"
}

struct AppConstant{
    static let DefaultCornerRadius = CGFloat(5.0)
}

struct ScreenSize { // Answer to OP's question
    
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    
}

struct DeviceType { //Use this to check what is the device kind you're working with
    
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_SE         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_7PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    
}

struct AppFont {
    static let kicomoon = "icomoon"
}

struct iOSVersion { //Get current device's iOS version
    
    static let SYS_VERSION_FLOAT  = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7               = (iOSVersion.SYS_VERSION_FLOAT >= 7.0 && iOSVersion.SYS_VERSION_FLOAT < 8.0)
    static let iOS8               = (iOSVersion.SYS_VERSION_FLOAT >= 8.0 && iOSVersion.SYS_VERSION_FLOAT < 9.0)
    static let iOS9               = (iOSVersion.SYS_VERSION_FLOAT >= 9.0 && iOSVersion.SYS_VERSION_FLOAT < 10.0)
    static let iOS10              = (iOSVersion.SYS_VERSION_FLOAT >= 10.0 && iOSVersion.SYS_VERSION_FLOAT < 11.0)
    static let iOS11              = (iOSVersion.SYS_VERSION_FLOAT >= 11.0 && iOSVersion.SYS_VERSION_FLOAT < 12.0)
    static let iOS12              = (iOSVersion.SYS_VERSION_FLOAT >= 12.0 && iOSVersion.SYS_VERSION_FLOAT < 13.0)
}
class CommonMethods {
    
   class func utcToLocalEpoch(utcDateEpoch: Int) -> Int {
        let utcDate = Date(timeIntervalSince1970: TimeInterval(utcDateEpoch / 1000) )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yy, hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")//TimeZone.current
        let localDateAndTimeString = dateFormatter.string(from: utcDate)

        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MM yy, hh:mm a"
        dateFormatter1.timeZone = TimeZone.current
        let localDate = dateFormatter1.date(from: localDateAndTimeString)
        let epoch = (localDate?.timeIntervalSince1970)! * 1000
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd MM yy, hh:mm a"
       // print(dateFormatter2.string(from: Date(timeIntervalSince1970: epoch / 1000 ) ))
        return Int(epoch)
    }
    
    func localToUTCEpoch(localDateEpoch : Int) -> Int {
        let localDate = Date(timeIntervalSince1970: TimeInterval(localDateEpoch / 1000) )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yy, hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateDateAndTimeString = dateFormatter.string(from: localDate)
        let utcDateAndTime = dateFormatter.date(from: dateDateAndTimeString)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMM yy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormatter1.string(from: utcDateAndTime!)
        let utcDate = dateFormatter1.date(from: dateString)
        let epoch = (utcDate?.timeIntervalSince1970)! * 1000
        
        return Int(epoch)
    }
    
    
    func UTCToLocal(utcDate:Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yy, hh:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: utcDate)
        return dateFormatter.date(from: dateString)!
    }
    
    func LocalToUTC(localDate: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yy, hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormatter.string(from: localDate)
        return dateFormatter.date(from: dateString)!
        
    }

    class func mediaUrl(url : URL) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)
        let filePath = fileURL.path
        let fileManager = FileManager.default
        
        
      
        
        if fileManager.fileExists(atPath: filePath) {
            debugPrint("FILE AVAILABLE")
            debugPrint(fileURL.path)
            return fileURL
        } else {
            debugPrint("FILE NOT AVAILABLE")
            debugPrint(url.path)
            
            if let visibleController = UIApplication.shared.keyWindow?.visibleViewController() , visibleController.isKind(of: QuestionnaireController.self){
                
                if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
                    
                    CustomActivityIndicator.startAnimating(message: kLoading.localisedString() + "...")
                    
                }else{
                    visibleController.view.showToast(toastMessage: "This survey need network to download multimedia.", duration: 2.0)
                    
                    visibleController.navigationController?.popViewController(animated: true)
                    
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)
                    return fileURL
                }
            }
            
            WebServiceMethods.sharedInstance.downloadMultimedia(nil ,url: url.absoluteString , completionHandler: { (succes, message) in
                DispatchQueue.main.async {
                    if let visibleController = UIApplication.shared.keyWindow?.visibleViewController() , visibleController.isKind(of: QuestionnaireController.self){
                        CustomActivityIndicator.stopAnimating()
                    }
                    if succes {
                        
                        // DatabaseHandler.insert(startDate: Int(timestamp), mediaUrl: message, endDate: Int(endDate))
                    }else{
                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController() , visibleController.isKind(of: QuestionnaireController.self){
                            visibleController.view.showToast(toastMessage: "Please try again later", duration: 2.0)
                            
                        }
                        debugPrint("fail")
                    }
                    
                }
                
            })
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)
            return fileURL
            //   [.removePreviousFile, .createIntermediateDirectories])
            //            return url
        }
    }
}

