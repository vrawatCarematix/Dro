//
//  ChangePassword.swift
//  DROapp
//
//  Created by Carematix on 05/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
// https://useyourloaf.com/blog/local-notifications-with-ios-10/

import UIKit
import UserNotifications
class ChangePassword: DROViewController {

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
        buttonConfirm.cornerRadius(radius: defaultCornerRadius)
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
