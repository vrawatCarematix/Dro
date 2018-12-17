//
//  SignInController.swift
//  DROapp
//
//  Created by Carematix on 04/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import LGSideMenuController
import NotificationCenter

class SignInController: UIViewController {
    
    //MARK: - Oultets

    @IBOutlet weak var labelPleaseCheck: UILabel!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet var imgBorderEmail: UIImageView!
    @IBOutlet var imgBorderPassword: UIImageView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var buttonShowPassword: UIButton!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var buttonSignin: UIButton!
    @IBOutlet var labelTitle: UILabel!
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseData()
        textfieldEmail.text = ""
        textfieldEmail.keyboardType = .emailAddress
        textfieldPassword.text = ""
        setText()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if textfieldEmail.text?.count == 0 ||  textfieldPassword.text?.count == 0 || !(textfieldEmail.text?.isValidEmail())! {
            buttonSignin.backgroundColor = .disableButton
            buttonSignin.isUserInteractionEnabled = false
        }else{
            buttonSignin.backgroundColor = .selectedButton
            buttonSignin.isUserInteractionEnabled = true
        }
    }
   
    //MARK:- Initialise Data
    
    func initialiseData() {
        labelTitle.setCustomFont()
        labelPleaseCheck.setCustomFont()
        textfieldEmail.setCustomFont()
        textfieldPassword.setCustomFont()
        buttonSignin.setCustomFont()
        buttonShowPassword.setCustomFont()
        buttonForgotPassword.setCustomFont()
        buttonSignin.cornerRadius(radius: 5.0)
        if UIDevice.current.userInterfaceIdiom == .pad{
            buttonSignin.cornerRadius(radius: 15.0)
        }else{
            buttonSignin.cornerRadius(radius: 7.0)
        }
        buttonSignin.backgroundColor = .disableButton
        buttonSignin.isUserInteractionEnabled = false
        if let firstTime = kUserDefault.value(forKey: kFirstTimeApp) as? String , firstTime == kNo {
            labelPleaseCheck.text = ""
        }else{
            labelPleaseCheck.text = ""
           // labelPleaseCheck.text = "Please check your email for temporary Password sent from *****@acare.com"
        }
    }
    
    //MARK:- Set Outlet Text
    func setText()  {
        labelTitle.text = kEmail_SignIn.localisedString()
        textfieldEmail.placeholder = kEmail.localisedString()
        textfieldPassword.placeholder = kPassword.localisedString()
        buttonSignin.setTitle(kSign_In.localisedString(), for: .normal)
        buttonForgotPassword.setTitle(kForgot_Password.localisedString().uppercased() + "?", for: .normal)
    }
    
    //MARK:- Textfield Delegate

    @IBAction func charaterChanged(_ sender: UITextField) {
        if textfieldEmail.text?.count == 0 ||  (textfieldPassword.text?.count)! < 8 || !(textfieldEmail.text?.isValidEmail())! {
            buttonSignin.backgroundColor = .disableButton
            buttonSignin.isUserInteractionEnabled = false
        }else{
            buttonSignin.backgroundColor = .selectedButton
            buttonSignin.isUserInteractionEnabled = true
        }
    }
    
    //MARK:- Button Action
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        buttonShowPassword.isSelected = !buttonShowPassword.isSelected
        if buttonShowPassword.isSelected {
            textfieldPassword.isSecureTextEntry = false
        }else{
            textfieldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let forgotPassword  = MainStoryboard.instantiateViewController(withIdentifier: AppController.ForgotPassword) as! ForgotPassword
        self.navigationController?.pushViewController(forgotPassword, animated: true)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        textfieldEmail.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        if textfieldEmail.text?.count == 0 {
            showErrorAlert(titleString: kAlert.localisedString(), message: kEmpty_Email.localisedString())
        }else if !(textfieldEmail.text?.isValidEmail())!{
            showErrorAlert(titleString: kAlert.localisedString(), message: kInvalid_Email.localisedString())
        }else if textfieldPassword.text?.count == 0{
            showErrorAlert(titleString: kAlert.localisedString(), message: kEmpty_Password.localisedString())
        }else{
            callLoginWebService()
        }
    }
    
    //MARK:- Web Service
    //Login
    func callLoginWebService()  {
       CustomActivityIndicator.startAnimating(message: kAuthenticating.localisedString() + "...")
        var params = [ pusername :textfieldEmail.text! , ppassword : textfieldPassword.text!.toBase64() , planguage : "EN",  psource : kIOS ]
        if let token =  AppDelegateInstance.notificationToken {
            params["dnToken"] = token
        }
        
        WebServiceMethods.sharedInstance.login(params){ (success, response, message ,responseHeader) in
            DispatchQueue.main.async {
                if success {
                    let userDefaults = UserDefaults.standard
                    if let htttpResponse = responseHeader.response ,let token = htttpResponse.allHeaderFields[pX_DRO_TOKEN] as? String {
                            userDefaults.setValue(token, forKey: AppConstantString.kToken)                        
                    }
                    DatabaseHandler.deleteAllTableData()
                    if let userName = response[pusername] as? String{
                        kUserDefault.set(userName, forKey: pusername)
                    }
                    if let firstName = response[kfirstName] as? String{
                        kUserDefault.set(firstName, forKey: kfirstName)
                    }
                    if let lastName = response[klastName] as? String{
                        kUserDefault.set(lastName, forKey: klastName)
                    }
                    if let userImage = response[kuserImage] as? String{
                        kUserDefault.set(userImage, forKey: kuserImage)
                    }
                    if let userId = response[kUserId] as? Int{
                        kUserDefault.set(userId, forKey: kUserId)
                    }
                    if let programUserId = response[kProgramUserId] as? Int{
                        kUserDefault.set(programUserId, forKey: kProgramUserId)
                    }
                    if let lastVisitedDate = response[klastVisitedDate] as? Int{
                        kUserDefault.set(lastVisitedDate, forKey: klastVisitedDate)
                    }
                    if let programInfo = response[pprogramInfo] as? [String :Any]{
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
                    if let organizationId = response[AppConstantString.kOrganizationId] as? Int {
                        userDefaults.setValue(organizationId, forKey: AppConstantString.kOrganizationId)
                    }
                    userDefaults.set(kYes, forKey: kFirstTimeApp)
                    userDefaults.synchronize()
                    CustomActivityIndicator.startAnimating(message: kSyncingData.localisedString() + "...")
                    self.getConfigData({ (success, message) in
                        DispatchQueue.main.async {
                            CustomActivityIndicator.stopAnimating()
                            if success || message == "No data found"{
                                let rootViewController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.DroTabBarController) as! DroTabBarController
                                let leftViewController = PostLoginStoryboard.instantiateViewController( withIdentifier: AppController.LeftViewController) as! LeftViewController
                                let sideMenuController = LGSideMenuController(rootViewController: rootViewController, leftViewController: leftViewController, rightViewController: nil)
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    sideMenuController.leftViewWidth = UIScreen.main.bounds.size.width * 0.6
                                }else{
                                    sideMenuController.leftViewWidth = UIScreen.main.bounds.size.width * 0.8
                                }
                                sideMenuController.leftViewPresentationStyle = .scaleFromBig
                                sideMenuController.rightViewWidth = 100.0;
                                sideMenuController.leftViewPresentationStyle = .slideBelow
                                let navC = UINavigationController(rootViewController: sideMenuController)
                                navC.setNavigationBarHidden(true, animated: false)
                                UIApplication.shared.keyWindow?.rootViewController = navC
                            }else{
                                self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                            }
                        }
                    })
                }else{
                    CustomActivityIndicator.stopAnimating()
                    if let htttpResponse = responseHeader.response  {
                            if htttpResponse.statusCode == 400 {
                                self.showErrorAlert(titleString: kPassword_Error.localisedString() , message: message)
                            }
                            else {
                                self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                            }
                    }else{
                        self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                    }
                }
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension SignInController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textfieldEmail{
            imgBorderEmail.backgroundColor = UIColor.appButtonColor
            imgBorderPassword.backgroundColor = UIColor.deselectedImageColor
            textfieldPassword.textColor = UIColor.black
            imgEmail.image = #imageLiteral(resourceName: "userDark")
        }else{
            imgBorderPassword.backgroundColor = UIColor.appButtonColor
            imgPassword.image = #imageLiteral(resourceName: "password-enter")
            imgBorderEmail.backgroundColor = UIColor.deselectedImageColor
            textfieldEmail.textColor = UIColor.deselectedOptionTextColor
            textfieldPassword.textColor = UIColor.black
        }
        return true
    }
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textfieldEmail{
            imgBorderEmail.backgroundColor = UIColor.deselectedImageColor
            textfieldEmail.textColor = UIColor.deselectedOptionTextColor
            imgEmail.image = #imageLiteral(resourceName: "user")
        }else{
            imgBorderPassword.backgroundColor = UIColor.deselectedImageColor
            textfieldPassword.textColor = UIColor.deselectedOptionTextColor
            imgPassword.image = #imageLiteral(resourceName: "password")
        }
    }
}

