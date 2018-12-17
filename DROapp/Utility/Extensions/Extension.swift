//
//  Extension.swift
//  DRO
//
//  Created by Carematix on 02/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x

import UIKit
import AVFoundation
import Alamofire
import UserNotifications
class Extension: NSObject {

}


extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if vc.isKind(of: UINavigationController.self)  {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
        } else if vc.isKind(of:UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func getFullDestinationUrl() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(self)
    }
}
extension UIViewController {
    
    func showAlertMessage(message : String) {
        let view = CustomErrorAlert.instanceFromNib(message: message)
        UIApplication.shared.keyWindow?.addSubview(view)
    }

    func showErrorAlert(titleString: String , message : String) {
        let view = CustomErrorAlert.instanceFromNib(title: titleString, message: message, okButtonTitle: "OK", type: .error)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    func logout() {
        let alert = UIAlertController(title: AppConstantString.appName, message: "Are you sure want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppConstantString.kYes, style: .default, handler: { (action) in
            CustomActivityIndicator.startAnimating( message: "Signing out..")
            WebServiceMethods.sharedInstance.getConfigData { (success, response, message) in
                DispatchQueue.main.async {
                    print(response)
                    CustomActivityIndicator.stopAnimating()
                    if success {
                        DatabaseHandler.deleteAllTableData()
                        kUserDefault.set(kYes, forKey: kLoggedIn)
                        let center = UNUserNotificationCenter.current()
                        center.removeAllPendingNotificationRequests()
                        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                            UserDefaults.standard.removeObject(forKey: key)
                        }
                        let loginViewController = MainStoryboard.instantiateViewController(withIdentifier: AppController.WelcomeScreen) as! WelcomeScreen
                        let navigationController  = UINavigationController(rootViewController: loginViewController)
                        UIApplication.shared.keyWindow?.rootViewController = navigationController
                    }else{
                        self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: AppConstantString.kNo, style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func rotateLandscape() {
        if UIDevice.current.orientation == .portrait {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
        }
    }
    
    func rotatePotrait() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight{
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    func getDeviceFontSize() -> CGFloat {
        var changeInFont = CGFloat(0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = UIScreen.main.bounds.size.width
            var siz = Int(width / 50)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  CGFloat((siz - 2))
        }else{
            let width = UIScreen.main.bounds.size.width
            
            var siz = Int(width / 20)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  CGFloat(siz - 16)
            
        }
//        var changeInFont = CGFloat(0)
//        switch UIScreen.main.nativeBounds.height {
//        case 960:
//            changeInFont = -1
//        case 1136:
//            changeInFont = 0
//        case 1334:
//            changeInFont =   1
//        case 1920, 2208:
//            changeInFont =   3
//        case 2436:
//            changeInFont =   3
//        case 2048:
//            changeInFont = 14
//        case 2224:
//            changeInFont =   15
//        case 2732:
//            changeInFont =   19
//        default:
//            print("unknown")
//        }
        return changeInFont
    }
    
    var AppDelegateInstance : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func getVideoThumbnail(url: URL) -> UIImage? {
        do {
            // var err: NSError? = nil
            let asset = AVURLAsset(url: url , options: nil) //AVURLAsset(URL: NSURL(fileURLWithPath: "/that/long/path"), options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 15, timescale: 1), actualTime: nil)  //imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil, error: &err)
            // !! check the error before proceeding
            let uiImage = UIImage(cgImage: cgImage)// UIImage(CGImage: cgImage)
            //let imageView = UIImageView(image: uiImage)
            return uiImage
        }catch {
            
        }
        return nil
        
    }
}

extension AVAsset {
    var screenSize: CGSize? {
        if let track = tracks(withMediaType: .video).first {
            let size = __CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform)
            return CGSize(width: abs(size.width), height: abs(size.height))
        }
        return nil
    }
}
extension CGFloat {
    
    func getDeviceFontSize() -> CGFloat {
        var changeInFont = CGFloat(0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = UIScreen.main.bounds.size.width
            var siz = Int(width / 50)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  CGFloat((siz - 2))
        }else{
            let width = UIScreen.main.bounds.size.width
            
            var siz = Int(width / 20)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  CGFloat(siz - 16)
            
        }
//        var changeInFont = CGFloat(0)
//        switch UIScreen.main.nativeBounds.height {
//        case 960:
//            changeInFont = -1
//        case 1136:
//            changeInFont = 0
//        case 1334:
//            changeInFont =   1
//        case 1920, 2208:
//            changeInFont =   3
//        case 2436:
//            changeInFont =   3
//        case 2048:
//            changeInFont = 10
//        case 2224:
//            changeInFont =   12
//        case 2732:
//            changeInFont =   19
//
//        default:
//            print("unknown")
//        }
       return changeInFont
    }
}

extension UIColor {
    open class var disableButton: UIColor{ get{
        return UIColor(red: 221.0/255.0, green: 225.0/255.0, blue: 232.0/255.0, alpha: 1.0) }
    }
    open class var selectedButton: UIColor{ get{
        return UIColor(red: 0, green: 156.0/255.0, blue: 211.0/255.0, alpha: 1.0) }
    }
    open class  var borderColor: UIColor{ get{
        return UIColor(red: 0.9412, green: 0.9529, blue: 0.9765, alpha: 1.0) }
    }
    open class  var appBackGroundColor: UIColor{ get{
        return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0) }
    }
    open class  var deselectedImageColor: UIColor{ get{
        return UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0) }
    }
    open class  var appButtonColor: UIColor{ get{
        return UIColor(red: 0, green: 156.0/255.0, blue: 222.0/255.0, alpha: 1.0) }
    }
    open class  var errorRed: UIColor{ get{
        return UIColor(red: 251.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1.0) }
    }
    open class  var selectedOptionTextColor: UIColor{ get{
        return UIColor(red: 21.0/255.0, green: 21.0/255.0, blue: 21.0/255.0, alpha: 1.0) }
    }
    open class  var deselectedOptionTextColor: UIColor{ get{
        return UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1.0) }
    }
    
    open class  var desableTextColor: UIColor{ get{
        return UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0) }
    }
}
extension UIView {
    
    func cornerRadius(radius : CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    func getCustomFontSize(size :Int ) -> Int  {
        
        var changeInFont = 0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = UIScreen.main.bounds.size.width
            var siz = Int(width / 50)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  (siz - 2)
        }else{
            let width = UIScreen.main.bounds.size.width
            
            var siz = Int(width / 20)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  siz - 16
            
        }
        return size + changeInFont
//        switch UIScreen.main.nativeBounds.height {
//        case 960:
//            changeInFont = -1
//        case 1136:
//            changeInFont = 0
//        case 1334:
//            changeInFont =   1
//        case 1920, 2208:
//            changeInFont =   3
//        case 2436:
//            changeInFont =   3
//        case 2048:
//            changeInFont = 14
//        case 2224:
//            changeInFont =   15
//        case 2732:
//            changeInFont =   19
//        default:
//            print("unknown")
//        }
//        return size + changeInFont
    }
    func setCustomFontSize(size :Int ) {
        var changeInFont = CGFloat(0)

        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = UIScreen.main.bounds.size.width
            var siz = Int(width / 50)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  CGFloat(siz - 2)
        }else{
            let width = UIScreen.main.bounds.size.width
            
            var siz = Int(width / 20)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  CGFloat(siz - 16)

        }
       
        
//
//        switch UIScreen.main.nativeBounds.height {
//        case 960:
//            changeInFont = -1
//        case 1136:
//            changeInFont = 0
//        case 1334:
//            changeInFont =   1
//        case 1920, 2208:
//            changeInFont =   3
//        case 2436:
//            changeInFont =   3
//        case 2048:
//            changeInFont = 14
//        case 2224:
//            changeInFont =   15
//        case 2732:
//            changeInFont =   19
//        default:
//            print("unknown")
//        }
        if let label = self as? UILabel{
            label.font = UIFont(name: label.font.fontName , size: CGFloat(size) + changeInFont)
        }else  if let button = self as? UIButton{
            button.titleLabel?.font = UIFont(name: (button.titleLabel?.font.fontName)! , size:   changeInFont + CGFloat(size))
        }else  if let textField = self as? UITextField{
            textField.font = UIFont(name: (textField.font!.fontName) , size:   changeInFont + CGFloat(size))
        }
    }
    
    

    func setCustomFont() {
//        var changeInFont = CGFloat(0)
//        switch UIScreen.main.nativeBounds.height {
//        case 960:
//            changeInFont = -1
//        case 1136:
//            changeInFont = 0
//        case 1334:
//            changeInFont =   1
//        case 1920, 2208:
//            changeInFont =   3
//        case 2436:
//            changeInFont =   3
//        case 2048:
//            changeInFont = 14
//        case 2224:
//            changeInFont =   15
//        case 2732:
//            changeInFont =   19
//        default:
//            print("unknown")
//        }
        var changeInFont = CGFloat(0)
       // 768 834 1024
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = UIScreen.main.bounds.size.width
            var siz = Int(width / 50)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  CGFloat(siz - 2)
        }else{
            let width = UIScreen.main.bounds.size.width
            var siz = Int(width / 20)
            if (Int(width) % 20 ) != 0 {
                siz += 1
            }
            changeInFont =  CGFloat(siz - 16)
        }
        
        if let label = self as? UILabel{
            label.font = UIFont(name: label.font.fontName , size: label.font.pointSize + changeInFont)
        }else  if let button = self as? UIButton{
            button.titleLabel?.font = UIFont(name: (button.titleLabel?.font.fontName)! , size: (button.titleLabel?.font.pointSize)! + changeInFont)
        }else  if let textField = self as? UITextField{
            textField.font = UIFont(name: (textField.font!.fontName) , size: (textField.font?.pointSize)! + changeInFont)
        }else  if let textView = self as? UITextView{
            textView.font = UIFont(name: (textView.font!.fontName) , size: (textView.font!.pointSize) + changeInFont)
        }
        
    }
 
}
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
extension UILabel {
    
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}
extension UILabel {
    func calculateMaxLines() -> Int {
       
        let maxSize = CGSize(width:  UIScreen.main.bounds.size.width - 20, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

extension UIView{
    func showToast(toastMessage:String,duration:CGFloat)
    {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = .clear//UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.6))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .black
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.init(name: kSFRegular, size: 17)
        lblMessage.setCustomFont()
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: bgView.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
       // lblMessage.frame = CGRect(x:((bgView.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (bgView.bounds.size.height/2) - ((expectedSizeTitle.height+16)/2), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        
        lblMessage.frame = CGRect(x:((bgView.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (bgView.bounds.size.height) - (expectedSizeTitle.height + 80), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)

        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        //self.addSubview(bgView)
        lblMessage.alpha = 0
        UIView.animateKeyframes(withDuration:TimeInterval(1) , delay: 0, options: [] , animations: {
            lblMessage.alpha = 1
        }, completion: {
            sucess in
            UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(0), options: [] , animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            }, completion: {
                sucess in
                bgView.removeFromSuperview()
            })
        })
    }
    
    
    func showToastAtCenter(toastMessage:String,duration:CGFloat)
    {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = .clear//UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.6))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .black
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.init(name: kSFRegular, size: 17)
        lblMessage.setCustomFont()
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: bgView.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        // lblMessage.frame = CGRect(x:((bgView.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (bgView.bounds.size.height/2) - ((expectedSizeTitle.height+16)/2), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        
        lblMessage.frame = CGRect(x:((bgView.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (bgView.bounds.size.height) - (expectedSizeTitle.height + 80), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.center = bgView.center
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        //self.addSubview(bgView)
        lblMessage.alpha = 0
        UIView.animateKeyframes(withDuration:TimeInterval(1) , delay: 0, options: [] , animations: {
            lblMessage.alpha = 1
        }, completion: {
            sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: TimeInterval(0), options: [] , animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            }, completion: {
                sucess in
                bgView.removeFromSuperview()
            })
        })
    }

}
extension CGFloat
{
    func getminimum(value2:CGFloat)->CGFloat
    {
        if self < value2
        {
            return self
        }
        else
        {
            return value2
        }
    }
}

//MARK: Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.

extension UILabel
{
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }

    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
//
//    override open func draw(_ rect: CGRect) {
//        if let insets = padding {
//            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//        } else {
//            self.drawText(in: rect)
//        }
//    }
//
//    override open var intrinsicContentSize: CGSize {
//        get {
//            var contentSize = super.intrinsicContentSize
//            if let insets = padding {
//                contentSize.height += insets.top + insets.bottom
//                contentSize.width += insets.left + insets.right
//            }
//            return contentSize
//        }
//    }
}


enum NotificationCategory : String{
    case ReminderCategory = "ReminderCategory"
    case dark = "ReminderCategory1"
}

extension UIViewController{
    
    func setUpcomingSurveyLocalNotification()  {
        DispatchQueue.main.async {
            
            let surveys = DatabaseHandler.getAllSurveyForNotificationSchedules()
            for survey in surveys{
                
                if let startTime = survey.startTime {
                    let dupliateSurvey = surveys.filter({ $0.startTime == startTime })
                    if dupliateSurvey.count == 1 {
                        if let surveyName = survey.surveyName , let sessionId = survey.surveySessionId {
                            let localDate = Date(timeIntervalSince1970: TimeInterval(startTime / 1000) )
                            self.setLocalNotification(identifier: sessionId, title: nil, body: surveyName + " DRO is about to start", category: .ReminderCategory , date: localDate)
                        }
                    }else{
                        let localDate = Date(timeIntervalSince1970: TimeInterval(startTime / 1000) )
                        self.setLocalNotification(identifier: startTime , title: nil, body: "You have \(dupliateSurvey.count) DROs scheduled today", category: .ReminderCategory , date: localDate)
                    }
                }
                
            }
        }
        
    }
    
    func setLocalNotification(identifier : Int,   title : String? , body : String , category: NotificationCategory , date: Date) {
        
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                if let notificationTitle = title{
                    content.title = notificationTitle
                }
                content.body = body
                content.sound = UNNotificationSound.default
                content.categoryIdentifier = category.rawValue
                // Swift
                let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                // Scheduling
                let identifier = "\(identifier)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        debugPrint(error)
                        // Something went wrong
                    }
                })
              
                
                // Notifications allowed
            }
        }
        
        
    }
    
    func getConfigData(_ completionHandler:@escaping (Bool, String)-> Void)  {
        WebServiceMethods.sharedInstance.getConfigData { (success, response, message) in
            DispatchQueue.main.async {
              //  debugPrint("Config ---> " + response.description)
                if success {
                    var configArray = [ConfigModel]()
                    if let form = response["form"] as? [String : Any] ,let common = form["common"] as? [String : Any] ,let bodiesArray = common["bodies"] as? [[[String : Any]]] {
                        for configDataArray in bodiesArray {
                            for configData in configDataArray {
                                let config = ConfigModel(jsonObject: configData)
                                configArray.append(config)
                            }
                        }
                    }
                    if let form = response["form"] as? [String : Any] ,let common = form["auth"] as? [String : Any] ,let bodiesArray = common["bodies"] as? [[[String : Any]]] {
                        for configDataArray in bodiesArray {
                            for configData in configDataArray {
                                let config = ConfigModel(jsonObject: configData)
                                configArray.append(config)
                            }
                        }
                    }
                    if let form = response["form"] as? [String : Any] ,let common = form["userNavigation"] as? [String : Any] ,let bodiesArray = common["bodies"] as? [[[String : Any]]] {
                        for configDataArray in bodiesArray {
                            for configData in configDataArray {
                                let config = ConfigModel(jsonObject: configData)
                                configArray.append(config)
                            }
                        }
                    }
                    var configDatabaseModelArray = [ConfigDatabaseModel]()
                    for config in configArray {
                        for configDatabaseModelData in config.fieldModelArray {
                            let configDatabaseModel = ConfigDatabaseModel()
                            configDatabaseModel.name = config.name
                            configDatabaseModel.type = config.type
                            configDatabaseModel.lastVisitedDate = config.lastVisitedDate
                            configDatabaseModel.fieldType = configDatabaseModelData.fieldType
                            configDatabaseModel.header = configDatabaseModelData.header
                            configDatabaseModel.descriptions = configDatabaseModelData.descriptions
                            configDatabaseModel.masterBankId = configDatabaseModelData.masterBankId
                            configDatabaseModel.url = configDatabaseModelData.url
                            configDatabaseModel.urlType = configDatabaseModelData.urlType
                            configDatabaseModel.fieldId = configDatabaseModelData.fieldId
                            configDatabaseModel.valuesArray = configDatabaseModelData.valuesArray
                            configDatabaseModel.text = configDatabaseModelData.text
                            configDatabaseModel.componentType = configDatabaseModelData.componentType
                            configDatabaseModel.placeHolder = configDatabaseModelData.placeHolder
                            configDatabaseModelArray.append(configDatabaseModel)
                        }
                    }                    
                    var _ = DatabaseHandler.insertIntoConfig(configArray: configDatabaseModelArray)
                    self.getDeclineReasonWebService { (success, response, message) in
                        
                        self.getLanguageData({ (success, message) in
                            completionHandler(success , message )
                        })
                        self.getProfileData { (success, response, message) in
                            
                        }
                        
                    }
                }else{
                    completionHandler(false , message )
                    //self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                }
            }
        }
    }
    func getLanguageData(_ completionHandler:@escaping (Bool, String)-> Void)  {
        WebServiceMethods.sharedInstance.getLanguageData{ (success, response, message) in
            DispatchQueue.main.async {
              //  debugPrint("Language ---> " + response.description)
                if success {
                    var languageArray = [LanguageModel]()
                    for languageData in response {
                        let language = LanguageModel(jsonObject: languageData)
                        languageArray.append(language)
                    }
                    var _ = DatabaseHandler.insertIntoLanguage(languageArray: languageArray)
                    let allLanguage = DatabaseHandler.getAllLanguage()
//                    for language in allLanguage{
//                        self.getLanguageDataForCode(language: language)
//                    }
                    let language = allLanguage.filter({ ($0.code ?? "") == "EN"})
                    if language.count > 0 {
                        self.getLanguageDataForCode(language: language[0], completionHandler: { (success , message ) in
                            self.getAllSurveyData({ (success, message) in
                                completionHandler(success , message )
                            })
                        })
                    }else{
                        self.getAllSurveyData({ (success, message) in
                            completionHandler(success , message )
                        })
                    }
                    
                   
                }else{
                    self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                    completionHandler(success , message )

                }
            }
        }
    }
    func getLanguageDataForCode( language : LanguageModel, completionHandler:@escaping (Bool, String)-> Void){
        WebServiceMethods.sharedInstance.getLanguageJson(language.code ?? "EN"){ (success, response, message) in
            DispatchQueue.main.async {
               // debugPrint("Language ---> " + response.description)
                if success {
                    let languageArray = language
                    language.languageJson = response
                    var _ = DatabaseHandler.insertIntoLanguage(languageArray: [languageArray])
                    completionHandler(success , message )

                }else{
                    completionHandler(success , "Failure" )
                }
            }
        }
    }
    
    func parseProfileOffline( response : [[String : Any]])  {
         var profileArray = [ProfileModel]()
        for profileData in response{
            let profileModel = ProfileModel(jsonObject: profileData)
            profileArray.append(profileModel)
        }

        if profileArray.filter({ $0.fieldType == "IMAGE_UPLOAD" }).count > 0 , let imageBase64 = profileArray.filter({ $0.fieldType == "IMAGE_UPLOAD" })[0].value {
            
            if let dataDecoded = Data(base64Encoded: imageBase64, options: Data.Base64DecodingOptions(rawValue: NSData.Base64DecodingOptions.RawValue(0))){
                if let _ =  UIImage(data: dataDecoded){
                    kUserDefault.set(imageBase64, forKey: kProflieImage)
                }
            }
        }
    }
    
    
    func getAllSurveyData(_ completionHandler:@escaping (Bool, String)-> Void) {
       // CustomActivityIndicator.startAnimating( message: "Syncing...")

        WebServiceMethods.sharedInstance.getAllSurvey{ (success, response, message) in
            DispatchQueue.main.async {
               // debugPrint("Survey ---> " + response.description)
                if success {
                    var surveySubmitArray = [SurveySubmitModel]()
                    for surveySubmitData in response {
                        let surveySubmit = SurveySubmitModel(jsonObject: surveySubmitData)
                        surveySubmitArray.append(surveySubmit)
                    }
                    var _ = DatabaseHandler.insertIntoSurvey(surveyArray: surveySubmitArray)
                    self.getCalenderData({ (success , message ) in
                        completionHandler(success , message )

                    })
                }else{
                    completionHandler(success , message )
                }
            }
        }
    }
    
    //MARK:- Fatch Calender Data
    
    func getCalenderData(_ completionHandler:@escaping (Bool, String)-> Void)  {
     
        let newDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        let toDate = Calendar.current.date(byAdding: .month, value: 2, to: Date())
        let fromepoch = (newDate?.timeIntervalSince1970)! * 1000
        let toepoch = ((toDate?.timeIntervalSince1970)! - 1) * 1000
        WebServiceMethods.sharedInstance.getScheduleCalender(Int(fromepoch), toDate: Int(toepoch)) { (success, response, message) in
           // debugPrint("getScheduleCalender ------>" + response.description)
            DispatchQueue.main.async {
                if success {
                   // var calenderSessionArray = [CalanderModel]()
                    for calenderSessionData in response{
                        let calenderSession = CalanderModel(jsonObject: calenderSessionData)
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
                            let _ = DatabaseHandler.insertIntoSurveySchedules(surveySchedulesArray: [surveyDatabase])
                        }
                        //calenderSessionArray.append(calenderSession)
                    }
//                    var surveyDatabaseModel = [SurveyScheduleDatabaseModel]()
//                    for calenderSession in calenderSessionArray{
//                        for session in calenderSession.sessionsArray {
//                            let surveyDatabase = SurveyScheduleDatabaseModel()
//                            surveyDatabase.surveyDate = calenderSession.date
//                            surveyDatabase.sessionCount = calenderSession.sessionCount
//                            surveyDatabase.startTime = session.startTime
//                            surveyDatabase.endTime = session.endTime
//                            surveyDatabase.surveyID = session.survey.id
//                            surveyDatabase.programSurveyId = session.survey.programSurveyId
//                            surveyDatabase.isPriority = session.survey.isPriority
//                            surveyDatabase.surveyName = session.survey.name
//                            surveyDatabase.surveySessionId = session.id
//                            surveyDatabase.percentageCompleted = session.userSession.percentageCompleted
//                            surveyDatabase.progressStatus = session.userSession.progressStatus
//                            surveyDatabase.timeSpent = session.userSession.timeSpent
//                            surveyDatabase.isDeclined = session.userSession.isDeclined
//                            surveyDatabaseModel.append(surveyDatabase)
//                        }
//                    }
//                    let _ = DatabaseHandler.insertIntoSurveySchedules(surveySchedulesArray: surveyDatabaseModel)
                    
                    
                    
//
//                    var calenderSessionArray = [CalanderModel]()
//                    for calenderSessionData in response{
//                        let calenderSession = CalanderModel(jsonObject: calenderSessionData)
//
//                        calenderSessionArray.append(calenderSession)
//                    }
//                    var surveyDatabaseModel = [SurveyScheduleDatabaseModel]()
//                    for calenderSession in calenderSessionArray{
//                        for session in calenderSession.sessionsArray {
//                            let surveyDatabase = SurveyScheduleDatabaseModel()
//                            surveyDatabase.surveyDate = calenderSession.date
//                            surveyDatabase.sessionCount = calenderSession.sessionCount
//                            surveyDatabase.startTime = session.startTime
//                            surveyDatabase.endTime = session.endTime
//                            surveyDatabase.surveyID = session.survey.id
//                            surveyDatabase.programSurveyId = session.survey.programSurveyId
//                            surveyDatabase.isPriority = session.survey.isPriority
//                            surveyDatabase.surveyName = session.survey.name
//                            surveyDatabase.surveySessionId = session.id
//                            surveyDatabase.percentageCompleted = session.userSession.percentageCompleted
//                            surveyDatabase.progressStatus = session.userSession.progressStatus
//                            surveyDatabase.timeSpent = session.userSession.timeSpent
//                            surveyDatabase.isDeclined = session.userSession.isDeclined
//                            surveyDatabaseModel.append(surveyDatabase)
//                        }
//                    }
//                    let _ = DatabaseHandler.insertIntoSurveySchedules(surveySchedulesArray: surveyDatabaseModel)

                    completionHandler(success , message )

                }
                else{
                    completionHandler(success , message )

                }
            }
        }
    }
    
    
    
    func getsurveySession( survey : SurveySubmitModel)  {
        WebServiceMethods.sharedInstance.surveySession(survey.surveySessionId ?? 0 ){ (success, response, message) in
            DispatchQueue.main.async {
                debugPrint("getsurveySession" + "--->" + response.debugDescription)
                if success {
                   let surveySubmit = SurveySubmitModel(jsonObject: response)
                    survey.pagesJson = surveySubmit.pagesJson
                    survey.pagesArray = surveySubmit.pagesArray
                    survey.pageNavigationJson = surveySubmit.pageNavigationJson
                    survey.pageNavigationArray = surveySubmit.pageNavigationArray
                    survey.userAnswerLogsJson = surveySubmit.userAnswerLogsJson
                    survey.userAnswerLogsArray = surveySubmit.userAnswerLogsArray
                    survey.lastAnswerPageId = surveySubmit.lastAnswerPageId
                    survey.progressStatus = surveySubmit.progressStatus
                    survey.percentageComplete = surveySubmit.percentageComplete
                    survey.lastSubmissionTime = surveySubmit.lastSubmissionTime
                    survey.timeSpent = surveySubmit.timeSpent
                    survey.declined = surveySubmit.declined
                    survey.userScheduleAssignId = surveySubmit.userScheduleAssignId
                    var _ = DatabaseHandler.insertIntoSurvey(surveyArray: [surveySubmit])
                }else{
                    self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                }
            }
        }
    }
    
    func uploadSurveyData(_ completionHandler:@escaping (Bool, String)-> Void) {
        let surveyToUpload = DatabaseHandler.getSurveyNotUploaded()
        if surveyToUpload.count == 0{
            completionHandler(true , "Success" )
        }
        var count = 0
        for survey in surveyToUpload {
            submitSurvey(survey) {(success, response, message) in
                count += 1
                if count == surveyToUpload.count {
                    completionHandler(success , message )
                }
            }
        }
    }
    
    func submitSurvey(_ survey: SurveySubmitModel, completionHandler:@escaping (Bool,[String : Any], String)-> Void) {

         let mediaArray = DatabaseHandler.getMediaOfSession(survey.surveySessionId ?? 0)
        
        if mediaArray.count > 0 {
            uploadMedia(mediaArray: mediaArray) { (success, message) in
                if success {
                    for media in mediaArray {
                        if media.answer == 0 {
                            completionHandler(false , ["":""] ,"Try again later" )

                        }
                        let answer = survey.userAnswerLogsArray.filter({ $0.questionId == media.questionId
                        })
                        if answer.count > 0 {
                            
                            survey.userAnswerLogsArray.filter({ $0.questionId == media.questionId })[0].fileId = media.answer
                        }
                    }
                    var userAnswerLogsJson = [[String : Any]]()
                    for page in survey.userAnswerLogsArray {
                        let dict = page.getDict()
                        userAnswerLogsJson.append(dict)
                    }
                    survey.userAnswerLogsJson = userAnswerLogsJson
                    WebServiceMethods.sharedInstance.submitSurveyResponse(survey){ (success, response, message) in
                        DispatchQueue.main.async {
                            if success {
                                survey.isUploaded = 1
                                var _ = DatabaseHandler.insertIntoSurveyData(survey: survey)
                                completionHandler(success ,response , message )
                                
                            }else{
                                // self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                                completionHandler(success , response , message )
                                
                            }
                        }
                    }
                }else{
                    completionHandler(false , [:] , message )
                }
            }
        }else{
            WebServiceMethods.sharedInstance.submitSurveyResponse(survey){ (success, response, message) in
                DispatchQueue.main.async {
                    if success {
                        survey.isUploaded = 1
                        var _ = DatabaseHandler.insertIntoSurveyData(survey: survey)
                        completionHandler(success ,response , message )
                        
                    }else{
                        completionHandler(success , response , message )
                    }
                }
            }
        }
       
    }
    
    func uploadMedia( mediaArray:  [MediaModel] ,  completionHandler:@escaping (Bool, String)-> Void) {
        
        var count = 0
        for media in mediaArray {
            if let name = media.name{
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                if let localPath = documentDirectory?.appending("/" + name) {
                    let url = URL(fileURLWithPath: localPath)
                    do {
                        let data = try Data(contentsOf: url)
                        WebServiceMethods.sharedInstance.upload(data: data, fileName: name) { (success, data, message) in
                            count += 1
                            if success && data != 0 {
                                media.isUploaded = 1
                                media.answer = data
                                let _ = DatabaseHandler.insertIntoMedia(media: media)
                            }
                            if count == mediaArray.count {
                                completionHandler(success , message )
                            }
                        }
                    }catch{
                        completionHandler(false , "Something went wrong , Please try again later" )
                    }
                }else{
                    completionHandler(false , "Something went wrong , Please try again later" )
                }
                
            }else{
                completionHandler(false , "Something went wrong , Please try again later" )
            }
           
        }
       
    }
    
    
    func updateMessage(_ completionHandler:@escaping (Bool, String)-> Void) {
        let messageToUpload = DatabaseHandler.getAllMessageToUpload()
        if messageToUpload.count == 0{
            completionHandler(true , "Success" )
        }
        var count = 0
        for message in messageToUpload {
            updateMessageOnServer(message) { (success, response, message, data) in
                count += 1
                if count == messageToUpload.count {
                    completionHandler(success , message )
                }
            }
        }
       
    }
    
    func updateMessageOnServer(_ messageModel: MessageModel , completionHandler:@escaping (Bool,[String : Any], String , DataResponse<Any>?)-> Void) {
        WebServiceMethods.sharedInstance.updateMessage(messageModel) { (success, response, message ,responseHeader) in
            DispatchQueue.main.async {
                if success {
                    messageModel.isUploaded = 1
                    let _ = DatabaseHandler.insertIntoMessageTable(messageArray: [messageModel])
                    completionHandler(success ,response, message , responseHeader )
                }else{
                    completionHandler(success ,response, message , responseHeader )
                }
            }
        }
    }
    
    func getDeclineReasonWebService( completionHandler:@escaping (Bool,[[String : Any]], String )-> Void) {
        WebServiceMethods.sharedInstance.getDeclineReason{(success, response, message ,responseHeader) in
            if success {
                var declinedReasonArray = [DeclinedModel]()
                for declinedata in response {
                    let decline = DeclinedModel(jsonObject: declinedata)
                    declinedReasonArray.append(decline)
                }
                let _ = DatabaseHandler.insertIntoDeclinedReason(declinedReasonArray: declinedReasonArray)
                completionHandler(success ,response, message  )
            }else{
                completionHandler(success ,response, message  )
            }
        }
    }
    
    func updateDeclineSurvey(_ completionHandler:@escaping (Bool, String)-> Void) {
        let declineSurveyToUpload = DatabaseHandler.getAllDeclinedSurvey()
        allDeclineSurveyWebService(declineSurveyToUpload) { (success, response, message) in
            DispatchQueue.main.async {
                if success {
                    completionHandler(success , message  )
                }
                else{
                    completionHandler(success , message  )
                }
            }
        }
    }
    
    func getProfileData(completionHandler:@escaping (Bool,[[String : Any]], String )-> Void) {
        WebServiceMethods.sharedInstance.getProfileData(){ (success, response, message) in
            if success {
                var  jsonData = Data()
                do {
                    jsonData = try JSONSerialization.data(withJSONObject: response , options: .prettyPrinted) as Data
                    kUserDefault.set(jsonData, forKey: kProfileData)
                    self.parseProfileOffline(response: response)
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
            completionHandler(success, response,message)
        }
    }
    
    func allDeclineSurveyWebService(_ declinedSurveyArray: [DeclinedSurveyModel] , completionHandler:@escaping (Bool,[String : Any], String )-> Void)  {
        if declinedSurveyArray.count > 0{
            
            WebServiceMethods.sharedInstance.surveyDecline(declinedSurveyArray){ (success, response, message ) in
                if success {
                    let _ = DatabaseHandler.deleteDeclinedSurvey()
                    completionHandler(success ,response, message )
                }else{
                    completionHandler(success ,response, message )
                }
            }
        }else{
            completionHandler(false ,[:], "Please try again later" )

        }
    }
    
    func changeLanguage() {
        if let languageCode = kUserDefault.value(forKey: kselectedLanguage) as? String , languageCode != "" {
            if languageCode == "ES"{
                kUserDefault.set(spanishJson, forKey: kDefaultEnglishDictionary)

            }else{
                kUserDefault.set(englishJson, forKey: kDefaultEnglishDictionary)

            }
            
            let languageModel = DatabaseHandler.getAllLanguage(languageCode)
            if languageModel.languageJson.count == 0 {
                CustomActivityIndicator.startAnimating(message: "Loading..")
                self.getLanguageDataForCode(language: languageModel, completionHandler: { (success , message ) in
                    DispatchQueue.main.async {
                        CustomActivityIndicator.stopAnimating()
                        for key in languageModel.languageJson.keys{
                            kUserDefault.set(languageModel.languageJson[key], forKey: key)
                        }
                        kUserDefault.synchronize()
                    }
                })
            }else{
                for key in languageModel.languageJson.keys{
                    kUserDefault.set(languageModel.languageJson[key], forKey: key)
                }
                kUserDefault.synchronize()
            }
        }else {
            let languageModel = DatabaseHandler.getAllLanguage("EN")
            for key in languageModel.languageJson.keys{
                kUserDefault.set(languageModel.languageJson[key], forKey: key)
            }
            kUserDefault.synchronize()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: klanguagechange), object: nil)
        
    }
    func getMessage( completionHandler:@escaping (Bool,[[String : Any]], String )-> Void) {
        WebServiceMethods.sharedInstance.getMessage(){ (success, response, message) in
            DispatchQueue.main.async {
                debugPrint(response)
                if success {
                    var messagArray = [MessageModel]()
                    for messageData in response{
                        let messageModel = MessageModel(jsonObject: messageData)
                        messagArray.append(messageModel)
                    }
                    var _ = DatabaseHandler.insertIntoMessageTable(messageArray: messagArray)
                    completionHandler(success ,response, message )

                }else{
                    completionHandler(success ,response, message )

                }
            }
        }
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
extension String {
    
    func localisedString() -> String{
        if let languageJson =  kUserDefault.value(forKey: klanguageDictionary) as? [String : String], let value = languageJson[self] , value != ""{
            return value
        }else if let languageJson =  kUserDefault.value(forKey: klanguageDictionary) as? [String : String], let value = languageJson[self.lowercased()] , value != ""{
            return value
        }else if let languageJson =  kUserDefault.value(forKey: kDefaultEnglishDictionary) as? [String : String], let value = languageJson[self] , value != ""{
            return value
        }else if let languageJson =  kUserDefault.value(forKey: kDefaultEnglishDictionary) as? [String : String], let value = languageJson[self.lowercased()] , value != ""{
            return value
        }
        return self
    }
}
