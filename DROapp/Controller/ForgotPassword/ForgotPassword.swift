//
//  ForgotPassword.swift
//  DROapp
//
//  Created by Carematix on 05/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet var imgBorder: UIImageView!
    @IBOutlet var otpView: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonGetOTP: UIButton!
    @IBOutlet weak var labelEnterOtp: UILabel!
    @IBOutlet weak var labelOtpDescription: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var buttonResend: UIButton!
    @IBOutlet weak var textfieldOtp: UITextField!
    @IBOutlet weak var buttonVerify: UIButton!
    @IBOutlet var labelTitle: UILabel!
    
    //MARK:- Variable
    
    var count = 45
    var timer = Timer()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseData()
        var rect = self.view.bounds
        rect.origin.y = rect.size.height + 200
        otpView.frame = rect
        self.view.addSubview(otpView)
        self.otpView.isHidden = true
        labelTitle.setCustomFont()
        labelTitle.text = "Forgot password"
        // Do any additional setup after loading the view.
    }
    
    func initialiseData() {
        labelDescription.setCustomFont()
        textFieldEmail.setCustomFont()
        textFieldEmail.autocorrectionType = .no
        
        buttonGetOTP.setCustomFont()
        buttonGetOTP.cornerRadius(radius: 5.0)
        buttonGetOTP.backgroundColor = .disableButton
        labelEnterOtp.setCustomFont()
        labelOtpDescription.setCustomFont()
        textfieldOtp.setCustomFont()
        labelTimer.setCustomFont()
        buttonResend.setCustomFont()
        buttonVerify.setCustomFont()
        buttonVerify.cornerRadius(radius: 5.0)
        labelDescription.text = "Just let us know your registered email address or mobile number"
        buttonGetOTP.isUserInteractionEnabled = false
        buttonGetOTP.backgroundColor = UIColor.disableButton
    }
    
    //MARK:- Textfield Delegate
    
    @IBAction func charaterChanged(_ sender: UITextField) {
        if sender == textfieldOtp {
            if (textfieldOtp.text?.count)! < 4 {
                buttonVerify.isUserInteractionEnabled = false
                buttonVerify.backgroundColor = UIColor.disableButton
            }else{
                buttonVerify.isUserInteractionEnabled = true
                buttonVerify.backgroundColor = UIColor.selectedButton
            }
        }else{
            if (textFieldEmail.text?.count)! < 4 {
                buttonGetOTP.isUserInteractionEnabled = false
                buttonGetOTP.backgroundColor = UIColor.disableButton
                
            }else{
                buttonGetOTP.isUserInteractionEnabled = true
                buttonGetOTP.backgroundColor = UIColor.selectedButton
            }
        }
    }
    
    //MARK:- Button Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getOTP(_ sender: UIButton) {
        textFieldEmail.resignFirstResponder()
        if textFieldEmail.text?.count == 0 {
            showErrorAlert(titleString: kAlert.localisedString(), message: "Please enter email id or phone number")
        }else{
            callForgotPasswordWebService()
        }
    }
    
    @IBAction func closeOtpView(_ sender: UIButton) {
        textfieldOtp.resignFirstResponder()
        timer.invalidate()
        count = 45
        self.otpView.animHide()
    }
    
    @IBAction func resendOtp(_ sender: UIButton) {
        textfieldOtp.resignFirstResponder()
        callForgotPasswordWebService()
        buttonResend.setTitleColor(UIColor.desableTextColor, for: .normal)
        buttonResend.isEnabled = false
        timer.invalidate()
        count = 45
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @IBAction func verifyOTP(_ sender: UIButton) {
        textfieldOtp.resignFirstResponder()
        callVerifyOtpWebService()
    }
    
    @objc func updateTimer() {
        labelTimer.text = "00:" + "\(count)" + "s"
        if count == 0 {
            labelTimer.text = ""
            timer.invalidate()
            buttonResend.isEnabled = true
            self.buttonResend.setTitleColor(UIColor.appButtonColor, for: .normal)
        }else{
            buttonResend.isEnabled = false
            buttonResend.setTitleColor(UIColor.desableTextColor, for: .normal)
        }
        count -= 1
    }
    
    func callForgotPasswordWebService()  {
        CustomActivityIndicator.startAnimating( message: "Authenticating...")
        WebServiceMethods.sharedInstance.resetPassword(textFieldEmail.text! ){ (success, response, message ,responseHeader) in
            DispatchQueue.main.async {
                print(response)
                CustomActivityIndicator.stopAnimating()
                if success {
                    self.buttonVerify.isUserInteractionEnabled = false
                    self.buttonVerify.backgroundColor = UIColor.disableButton
                    self.labelOtpDescription.text = "Please enter 4-digit OTP sent via SMS to your registered mobile number " + (self.textFieldEmail.text ?? "") + "."
                    self.textfieldOtp.text = ""
                    self.buttonResend.isEnabled = false
                    self.buttonResend.setTitleColor(UIColor.desableTextColor, for: .normal)
                    self.timer.invalidate()
                    self.count = 45
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                    if self.otpView.isHidden == true {
                        self.otpView.animShow()
                    }
                }else{
                    if let htttpResponse = responseHeader.response  {
                        if htttpResponse.statusCode == 400 {
                            self.showErrorAlert(titleString: "Invalid Email", message: message)
                        }else  if htttpResponse.statusCode == 200 {
                            self.showErrorAlert(titleString: "Invalid Email", message: message)
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
    
    func callVerifyOtpWebService()  {
        CustomActivityIndicator.startAnimating( message: "Verifying...")
        WebServiceMethods.sharedInstance.verifyOtp(textFieldEmail.text!, otp: textfieldOtp.text!) { (success, response, message ,responseHeader) in
            DispatchQueue.main.async {
                print(response)
                CustomActivityIndicator.stopAnimating()
                if success {
                    self.timer.invalidate()
                    self.count = 45
                    self.otpView.animHide()
                    let resetPassword = MainStoryboard.instantiateViewController(withIdentifier: AppController.ResetPassword) as! ResetPassword
                    resetPassword.emailId = self.textFieldEmail.text!
                    resetPassword.otp = self.textfieldOtp.text!
                    self.navigationController?.pushViewController(resetPassword, animated: true)
                }else{
                    if let htttpResponse = responseHeader.response  {
                        if htttpResponse.statusCode == 400 {
                            self.showErrorAlert(titleString: "Invalid OTP", message: message)
                        }else  if htttpResponse.statusCode == 200 {
                            self.showErrorAlert(titleString: "Invalid OTP", message: message)
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

extension UIView{
    func animShow(){
        var rect = self.bounds
        rect.origin.y = rect.size.height
        self.frame = rect
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y = self.bounds.height / 2
                        //self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            var rect = self.bounds
            rect.origin.y = rect.size.height + 200
            self.frame = rect
            self.isHidden = true
        })
    }
}

extension ForgotPassword : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textfieldOtp {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 4
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail{
            imgBorder.backgroundColor = UIColor.appButtonColor
            textFieldEmail.textColor = UIColor.black
            imgEmail.image = #imageLiteral(resourceName: "userDark")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldEmail{
            imgBorder.backgroundColor = UIColor.deselectedImageColor
            textFieldEmail.textColor = UIColor.deselectedOptionTextColor
            imgEmail.image = #imageLiteral(resourceName: "user")
        }
    }
}
