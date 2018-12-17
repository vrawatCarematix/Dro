//
//  ViewController.swift
//  DROapp
//
//  Created by Carematix on 04/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import UserNotifications
import NotificationCenter
class WelcomeScreen: UIViewController {

    //MARK: - Outlets

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var labelWeWould: UILabel!
    @IBOutlet weak var buttonLegalStatement: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var microsoftView: UIView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var buttonEmail: UIButton!
    @IBOutlet weak var imgMicrosoft: UIImageView!
    @IBOutlet weak var labelMicrosoft: UILabel!
    @IBOutlet weak var buttonMIcrosoft: UIButton!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseData()
        deleteOldData()
        NCWidgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.carematix.DRO.DROWidget")
        let currentLocale = NSLocale.current
        if let countryCode = currentLocale.regionCode   {
            debugPrint(countryCode)
        }
        debugPrint(TimeZone.current.identifier)
        if let language = Bundle.main.preferredLocalizations.first{
            debugPrint(language)
        }
        kUserDefault.set(englishJson, forKey: kDefaultEnglishDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText()
        //Hiding default navigation bar
        self.navigationController?.isNavigationBarHidden = true
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func deleteOldData() {
        let fileManager = FileManager.default
        if let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            if let filePaths = try? fileManager.contentsOfDirectory(at: myDocuments, includingPropertiesForKeys: nil, options: [])  {
                for filePath in filePaths {
                    try? fileManager.removeItem(at: filePath)
                }
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key)
                }
                let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                kUserDefault.set(englishJson, forKey: kDefaultEnglishDictionary)
                DatabaseHandler.createDatabaseIfNeeded()
                kUserDefault.set(appVersion, forKey: kAppCurrentVersion)
            }
        }
    }
    
    //Initialise Data
    func initialiseData() {
        //Applying Font
        labelWelcome.setCustomFont()
        labelWeWould.setCustomFont()
        labelEmail.setCustomFont()
        labelMicrosoft.setCustomFont()
        buttonLegalStatement.setCustomFont()
        buttonLegalStatement.isHidden = true
        emailView.backgroundColor = .appButtonColor
        microsoftView.backgroundColor = .white
        if UIDevice.current.userInterfaceIdiom == .pad{
            emailView.cornerRadius(radius: 15.0)
            microsoftView.cornerRadius(radius: 15.0)
        }else{
            emailView.cornerRadius(radius: 7.0)
            microsoftView.cornerRadius(radius: 7.0)
        }
    }
    
    //Initialise Data
    func setText() {
        labelWelcome.text = kWelcome.localisedString()
        labelWeWould.text = kWelcome_Description.localisedString()
        labelEmail.text = kEmail_SignIn.localisedString()
        labelMicrosoft.text = kMicrosoft_SignIn.localisedString()
    }

    //MARK:- Button Action
    @IBAction func signInWithMicrosoft(_ sender: UIButton) {
        self.view.showToast(toastMessage: kCurrently_Not_Available.localisedString(), duration: 2.0)
    }
    
    @IBAction func signInUsingEmail(_ sender: UIButton) {
        let signInScreen = MainStoryboard.instantiateViewController(withIdentifier: AppController.SignInController) as! SignInController
        self.navigationController?.pushViewController(signInScreen, animated: true)
    }
    
    @IBAction func showLegalStaetment(_ sender: UIButton) {

    }
}

