//
//  ResetPassword.swift
//  DROapp
//
//  Created by Carematix on 05/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ResetPassword: UIViewController {

    //MARK: - Variable

    var emailId = String()
    var otp = String()
    
    //MARK: - Outlet

    @IBOutlet weak var imgNewPassword: UIImageView!
    @IBOutlet var imgBorderConfirmPassword: UIImageView!
    @IBOutlet var imgBorderNewPassword: UIImageView!
    @IBOutlet weak var textfieldNewPassword: UITextField!
    @IBOutlet weak var buttonShowNewPassword: UIButton!
    @IBOutlet weak var imgConfirmNewPassword: UIImageView!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonShowConfirmPassword: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet var labelTitle: UILabel!
    
    //MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Initialise Data
    
    func initialiseData() {
        labelTitle.setCustomFont()
        labelTitle.text = "Reset password"
        textfieldConfirmPassword.setCustomFont()
        textfieldNewPassword.setCustomFont()
        buttonSubmit.setCustomFont()
        buttonSubmit.cornerRadius(radius: 5.0)
        buttonSubmit.backgroundColor = .disableButton
        buttonSubmit.isUserInteractionEnabled = false
    }
    
    @IBAction func characterChanged(_ sender: Any) {
        
        if ((textfieldNewPassword.text?.count)! < 8 ) || ((textfieldConfirmPassword.text?.count)! < 8 ){
            buttonSubmit.backgroundColor = UIColor.disableButton
            buttonSubmit.isUserInteractionEnabled = false
        }else{
            buttonSubmit.backgroundColor = UIColor.selectedButton
            buttonSubmit.isUserInteractionEnabled = true
        }
    }
    
    //MARK:- Button Action

    @IBAction func showNewPassword(_ sender: UIButton) {
        buttonShowNewPassword.isSelected = !buttonShowNewPassword.isSelected
        if buttonShowNewPassword.isSelected {
            textfieldNewPassword.isSecureTextEntry = false
        }else{
            textfieldNewPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func showConfirmPassword(_ sender: UIButton) {
        buttonShowConfirmPassword.isSelected = !buttonShowConfirmPassword.isSelected
        if buttonShowConfirmPassword.isSelected {
            textfieldConfirmPassword.isSecureTextEntry = false
        }else{
            textfieldConfirmPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: UIButton){
        
        if (textfieldNewPassword.text?.count)! < 8 {
            showErrorAlert(titleString: "Error", message: "Password length should be minimum 8 characters")
        }else if textfieldNewPassword.text != textfieldConfirmPassword.text{
            showErrorAlert(titleString: "Error", message: "The Passwords do not match")
        }else{
            callResetWebService()
        }
    }
    
    func callResetWebService()  {
        CustomActivityIndicator.startAnimating( message: "Reseting...")
        WebServiceMethods.sharedInstance.reset(emailId, otp: otp, password: textfieldNewPassword.text!.toBase64()) { (success, response, message ,responseHeader) in
            DispatchQueue.main.async {
                debugPrint(response)
                CustomActivityIndicator.stopAnimating()
                if success {
                    let successChangePassword = MainStoryboard.instantiateViewController(withIdentifier: AppController.SuccessChangePassword) as! SuccessChangePassword
                    self.navigationController?.pushViewController(successChangePassword, animated: true)
                    
                }else{
                        self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                }
            }
        }
    }
    
}
extension ResetPassword : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textfieldNewPassword{
            imgBorderNewPassword.backgroundColor = UIColor.appButtonColor
            imgBorderConfirmPassword.backgroundColor = UIColor.deselectedImageColor
            textfieldNewPassword.textColor = UIColor.black
            imgNewPassword.image =  #imageLiteral(resourceName: "password-enter")            
        }else{
            imgBorderConfirmPassword.backgroundColor = UIColor.appButtonColor
            imgConfirmNewPassword.image = #imageLiteral(resourceName: "password-enter")
            imgBorderNewPassword.backgroundColor = UIColor.deselectedImageColor
            textfieldNewPassword.textColor = UIColor.deselectedOptionTextColor
            textfieldConfirmPassword.textColor = UIColor.black
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textfieldNewPassword{
            imgBorderNewPassword.backgroundColor = UIColor.deselectedImageColor
            textfieldNewPassword.textColor = UIColor.deselectedOptionTextColor
            imgNewPassword.image = #imageLiteral(resourceName: "password")
        }else{
            imgBorderConfirmPassword.backgroundColor = UIColor.deselectedImageColor
            textfieldConfirmPassword.textColor = UIColor.deselectedOptionTextColor
            imgConfirmNewPassword.image = #imageLiteral(resourceName: "password")
            
        }
    }
}
