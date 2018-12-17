//
//  ChangePassword.swift
//  DROapp
//
//  Created by Carematix on 05/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
// https://useyourloaf.com/blog/local-notifications-with-ios-10/

import UIKit
import UserNotifications
class ChangePassword: UIViewController {

    //MARK: - Outlet

    @IBOutlet var imgNewPasswordBorder: UIImageView!
    @IBOutlet var imgConfirmPasswordBorder: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet weak var imgOldPassword: UIImageView!
    @IBOutlet weak var textfieldOldPassword: UITextField!
    @IBOutlet weak var buttonShowOldPassword: UIButton!
    @IBOutlet var imgBorderOldPassword: UIImageView!
    @IBOutlet weak var imgNewPassword: UIImageView!
    @IBOutlet weak var textfieldNewPassword: UITextField!
    @IBOutlet weak var buttonShowNewPassword: UIButton!
    @IBOutlet weak var imgConfirmNewPassword: UIImageView!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonShowConfirmPassword: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    //MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let notification = UILocalNotification()
//        notification.fireDate = Date(timeIntervalSinceNow: 25)
//        notification.alertBody = "Hey you have a Dro Survey"
//        notification.alertAction = "be awesome!"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.userInfo = ["CustomField1": "w00t"]
//        UIApplication.shared.scheduleLocalNotification(notification)

  

            
            let center = UNUserNotificationCenter.current()
            
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Don't forget"
                    content.body = "Hey you have a Dro Survey"
                    content.sound = UNNotificationSound.default
                    content.categoryIdentifier = "UYLReminderCategory"

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15,
                                                                    repeats: false)
                    
                    let date = Date(timeIntervalSinceNow: 3600)
                    let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
                    // Swift
                    let trigger1 = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                                repeats: false)
                    
                    //Daily
                    let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                    let trigger2 = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                    
                    //Weekly
                    let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour,.minute,.second,], from: date)
                    let trigger3 = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
                    
                    
                    // Scheduling
                    let identifier = "UYLLocalNotification1"
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            // Something went wrong
                        }
                    })
                    let identifier1 = "UYLLocalNotification"
                    content.title = "Don'tdd1 forget"

                    let request1 = UNNotificationRequest(identifier: identifier1,
                                                        content: content, trigger: trigger)

                    center.add(request1, withCompletionHandler: { (error) in
                        if let error = error {
                            // Something went wrong
                        }
                    })
                    
                    let identifier2 = "UYLLocalNotification2"
                    content.title = "Don'tdd 2 forget"

                    let request2 = UNNotificationRequest(identifier: identifier2,
                                                         content: content, trigger: trigger)
                    
                    center.add(request2, withCompletionHandler: { (error) in
                        if let error = error {
                            // Something went wrong
                        }
                    })
                    // Swift
                   
                    
                    // Notifications allowed
                }
            }

        
   
//        You could try to remove all notifications if this is acceptable in your context. Like this:
//
//        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
//            UIApplication.sharedApplication().cancelLocalNotification(notification)
//        }
//
//        UIApplication.sharedApplication().cancelAllLocalNotifications()
//        Or as stated by Gerard Grundy for Swift 4:
//
//        UNUserNotificationCenter.current().removeAllPendingNotificat‌​ionRequests()
//
        
//        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
//
//        if settings.types == .none {
//            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(ac, animated: true, completion: nil)
//            return
//        }
        initialiseData()
        setText()
    }

    
    //Initialise Data
    
    func initialiseData() {
        labelTitle.setCustomFont()
        textfieldOldPassword.setCustomFont()
        textfieldNewPassword.setCustomFont()
        textfieldConfirmPassword.setCustomFont()
        buttonConfirm.setCustomFont()
        buttonConfirm.cornerRadius(radius: 5.0)
        buttonConfirm.backgroundColor = .disableButton
        buttonConfirm.isUserInteractionEnabled = false
    }
    
    func setText()  {
        labelTitle.text = kChange_Password.localisedString()
        textfieldOldPassword.placeholder = kCurrent_Password.localisedString()
        textfieldNewPassword.placeholder = kNew_Password.localisedString()
        textfieldConfirmPassword.placeholder = kConfirm_Password.localisedString()
        buttonConfirm.setTitle(kConfirm.localisedString(), for: .normal)
    }
    
    //MARK:- Textfield Delegate

    @IBAction func characterChanged(_ sender: UITextField) {
        if ((textfieldNewPassword.text?.count)! < 8 ) || ((textfieldConfirmPassword.text?.count)! < 8 ) || ((textfieldOldPassword.text?.count)! < 8 ) {
            buttonConfirm.backgroundColor = UIColor.disableButton
            buttonConfirm.isUserInteractionEnabled = false
        }else{
            buttonConfirm.backgroundColor = UIColor.selectedButton
            buttonConfirm.isUserInteractionEnabled = true
        }
    }
    
    //MARK:- Button Action

    @IBAction func showOldPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textfieldOldPassword.isSecureTextEntry = false
        }else{
            textfieldOldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func showNewPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textfieldNewPassword.isSecureTextEntry = false
        }else{
            textfieldNewPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func showConfirmPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textfieldConfirmPassword.isSecureTextEntry = false
        }else{
            textfieldConfirmPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        if textfieldNewPassword.text != textfieldConfirmPassword.text{
            showErrorAlert(titleString: kError.localisedString() , message: kPassword_Mismatch.localisedString() )
        }else{
            callResetWebService()
        }
    }
    
    func callResetWebService()  {
        CustomActivityIndicator.startAnimating( message: kUpdating.localisedString() +  "...")
        WebServiceMethods.sharedInstance.changePassword(textfieldOldPassword.text!.toBase64(), newPassword: textfieldNewPassword.text!.toBase64() ) { (success, response, message) in
            DispatchQueue.main.async {
                debugPrint(response)
                CustomActivityIndicator.stopAnimating()
                if success {
                    let successChangePassword = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.SuccessChangePassword) as! SuccessChangePassword
                    self.navigationController?.pushViewController(successChangePassword, animated: true)
                }else{
                        self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                }
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
extension ChangePassword : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textfieldOldPassword{
            imgBorderOldPassword.backgroundColor = UIColor.appButtonColor
            imgNewPasswordBorder.backgroundColor = UIColor.deselectedImageColor
            imgConfirmPasswordBorder.backgroundColor = UIColor.deselectedImageColor

            textfieldOldPassword.textColor = UIColor.black
            imgOldPassword.image =  #imageLiteral(resourceName: "password-enter")
        }else if textField == textfieldNewPassword{
            imgNewPasswordBorder.backgroundColor = UIColor.appButtonColor
            imgBorderOldPassword.backgroundColor = UIColor.deselectedImageColor
            imgConfirmPasswordBorder.backgroundColor = UIColor.deselectedImageColor

            textfieldNewPassword.textColor = UIColor.black
            imgNewPassword.image =  #imageLiteral(resourceName: "password-enter")
        }else{
            imgConfirmPasswordBorder.backgroundColor = UIColor.appButtonColor
            imgConfirmNewPassword.image = #imageLiteral(resourceName: "password-enter")
            imgNewPasswordBorder.backgroundColor = UIColor.deselectedImageColor
            imgConfirmPasswordBorder.backgroundColor = UIColor.deselectedImageColor

            textfieldNewPassword.textColor = UIColor.deselectedOptionTextColor
            textfieldConfirmPassword.textColor = UIColor.black
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textfieldOldPassword{
            imgBorderOldPassword.backgroundColor = UIColor.deselectedImageColor
            textfieldOldPassword.textColor = UIColor.deselectedOptionTextColor
            imgOldPassword.image = #imageLiteral(resourceName: "password")
            
        }else if textField == textfieldNewPassword{
            imgNewPasswordBorder.backgroundColor = UIColor.deselectedImageColor
            textfieldNewPassword.textColor = UIColor.deselectedOptionTextColor
            imgNewPassword.image = #imageLiteral(resourceName: "password")
            
        }else{
            imgConfirmPasswordBorder.backgroundColor = UIColor.deselectedImageColor
            textfieldConfirmPassword.textColor = UIColor.deselectedOptionTextColor
            imgConfirmNewPassword.image = #imageLiteral(resourceName: "password")
        }
    }
}
