//
//  SuccessChangePassword.swift
//  DROapp
//
//  Created by Carematix on 05/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class SuccessChangePassword: DROViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var labelSucces: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    //MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialisedata()
        if let loggedIn = kUserDefault.value(forKey: kLoggedIn) as? String, loggedIn == kYes {
            self.perform(#selector(backToRoot), with: nil, afterDelay: 3.0)
        }
        setText()
    }
    
    //Initialise Data

    func initialisedata() {
        labelSucces.setCustomFont()
        labelDescription.setCustomFont()
        buttonContinue.setCustomFont()
        buttonContinue.cornerRadius(radius: defaultCornerRadius)
    }
    
    func setText()  {
        labelSucces.text = kSuccess.localisedString() + " !"
        labelDescription.text = kPassword_Changed.localisedString()
        buttonContinue.setTitle(kContinue_To_Login.localisedString() , for: .normal)
    }
    
    @objc func backToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Button Action

    @IBAction func continueToLogin(_ sender: UIButton) {
       
        if let controllerArray = self.navigationController?.viewControllers {
            for controller in controllerArray {
                if controller.isKind(of: SignInController.self){
                     self.navigationController?.popToViewController(controller, animated: true)
                    return
                }
            }
        }
        let signInScreen = MainStoryboard.instantiateViewController(withIdentifier: AppController.SignInController) as! SignInController
        self.navigationController?.pushViewController(signInScreen, animated: true)
    }
    
}
