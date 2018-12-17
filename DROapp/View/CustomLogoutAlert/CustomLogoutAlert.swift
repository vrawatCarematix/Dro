//
//  CustomAlert.swift
//  blip
//
//  Created by Carematix on 29/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

@objc protocol CustomLogoutAlertDelegate {

    @objc optional func clickOnOKButton(_ sender: CustomLogoutAlert)
}
class CustomLogoutAlert: UIView {
    
    @IBOutlet var buttonCancel: UIButton!
    @IBOutlet weak var labalTitle: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var alertView: CardView!
    @IBOutlet weak var buttonOk: UIButton!
    weak var delegate: CustomLogoutAlertDelegate?
    
    var message = String()
    override func awakeFromNib() {
        buttonCancel.setCustomFont()
        labelMessage.setCustomFont()
        buttonOk.setCustomFont()
        labalTitle.setCustomFont()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib(title : String ,message : String) -> UIView {
        let view = UINib(nibName: "CustomLogoutAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomLogoutAlert
        view.frame = UIScreen.main.bounds
        view.labelMessage.text = message
        view.labalTitle.text = title
        
        view.alertView.cornerRadius = 10.0
        view.alertView.clipsToBounds = true
        return view
    }
    class func instanceFromNib(title : String , message : String , okButtonTitle : String ,type : AlertType ) -> UIView {
        let view = UINib(nibName: "CustomWarningAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomWarningAlert
        view.frame = UIScreen.main.bounds
        view.labelMessage.text = message
        
        view.labalTitle.text = title
        if type == .error {
            view.labalTitle.textColor = UIColor.errorRed
        }
        view.buttonOk.setTitle(okButtonTitle, for: .normal)
        view.alertView.cornerRadius = 10.0
        view.alertView.clipsToBounds = true
        return view
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        self.removeFromSuperview()
        
    }
    @IBAction func okButtonClick(_ sender: UIButton) {
        
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            
            
            CustomActivityIndicator.startAnimating( message: "Signing out..")
            
            WebServiceMethods.sharedInstance.logout{ (success, response, message) in
                DispatchQueue.main.async {
                    debugPrint(response)
                    CustomActivityIndicator.stopAnimating()
                    if success {
                        self.removeFromSuperview()
                        
                        DatabaseHandler.deleteAllTableData()
                        kUserDefault.set(kYes, forKey: kLoggedIn)
                        
                        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                            UserDefaults.standard.removeObject(forKey: key)
                        }
                        let loginViewController = MainStoryboard.instantiateViewController(withIdentifier: AppController.WelcomeScreen) as! WelcomeScreen
                        let navigationController  = UINavigationController(rootViewController: loginViewController)
                        UIApplication.shared.keyWindow?.rootViewController = navigationController
                    }else{
                        
                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                            visibleController.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                        }
                    }
                }
            }
        }else{
            
        }
        
        //        if let delegat = delegate {
        //            delegat.clickOnOKButton!(self)
        //        }
        //        self.removeFromSuperview()
    }
}
