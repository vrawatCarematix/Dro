//
//  LeftViewController.swift
//  DROapp
//
//  Created by Vikas on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import LGSideMenuController
import SDWebImage
class LeftViewController: UIViewController {
    
    //MARK:- Outlet

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var languageView: UIView!
    @IBOutlet var labelLanguageTitle: UILabel!
    @IBOutlet var languageBackButton: UIButton!
    @IBOutlet var languageTable: UITableView!
    @IBOutlet var buttonDisclaimer: UIButton!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelLanguage: UILabel!
    @IBOutlet var labelLogout: UILabel!
    @IBOutlet var buttonPrivacy: UIButton!
    @IBOutlet var buttonTerms: UIButton!
    @IBOutlet var labelChangePassword: UILabel!
    @IBOutlet var legalStamentButton: UIButton!
    @IBOutlet var labelVersion: UILabel!
    
    //MARK:- Variables

    var languageNameArray = [LanguageModel]()
    var selectedLanguageCode = "EN"

    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelName.setCustomFont()
        labelLogout.setCustomFont()
        labelLanguage.setCustomFont()
        labelChangePassword.setCustomFont()
        legalStamentButton.setCustomFont()
        buttonTerms.setCustomFont()
        buttonPrivacy.setCustomFont()
        buttonDisclaimer.setCustomFont()
        labelLanguageTitle.setCustomFont()
        labelVersion.setCustomFont()
        if  let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ,
            let _ = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String{
            labelVersion.text = "Version: " + versionNumber
        }else{
            labelVersion.text = ""
            
        }
        languageTable.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(hideLanguageView(notifcation:)), name: NSNotification.Name(rawValue: "LGSideMenuHideLeftViewAnimationsNotification") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserData), name: NSNotification.Name(rawValue: kReloadUserData) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)
        
        if let languageCode = kUserDefault.value(forKey: kselectedLanguage) as? String , languageCode != "" {
            selectedLanguageCode = languageCode
        }
        setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        languageNameArray = DatabaseHandler.getAllLanguage()
        languageTable.reloadData()
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.clipsToBounds = true
        }
        setText()

    }
    
   @objc func reloadUserData()  {
        setText()
    }

    //MARK:- Changes Text on language Changes

    @objc func setText()  {
        if let firstName = kUserDefault.value(forKey: kfirstName) as? String {
            if let lastName = kUserDefault.value(forKey: klastName) as? String {
                labelName.text = firstName + " " + lastName
            }else{
                labelName.text = firstName
            }
        }else{
            labelName.text = ""
        }
        if let userImage = kUserDefault.value(forKey: kProflieImage) as? String {
            if let dataDecoded = Data(base64Encoded: userImage, options: Data.Base64DecodingOptions(rawValue: NSData.Base64DecodingOptions.RawValue(0))){
                if let image =  UIImage(data: dataDecoded){
                    self.profileImageView.image = image
                }
            }
        }
        labelLanguageTitle.text = kLanguage.localisedString().capitalized
        labelLanguage.text = kLanguage.localisedString().capitalized
        labelLogout.text = kLogout.localisedString().capitalized
        labelChangePassword.text = kChange_Password.localisedString().capitalized
        buttonTerms.setTitle(kTerms_Conditions.localisedString().capitalized, for: .normal)
        buttonDisclaimer.setTitle(kDisclaimer.localisedString().capitalized, for: .normal)
        buttonPrivacy.setTitle(kPrivacy_Policy.localisedString().capitalized, for: .normal)
        legalStamentButton.setTitle(kLegal_Statement.localisedString().capitalized, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var rect = self.view.bounds
        rect.origin.x = self.view.bounds.width
        self.languageView.frame = rect
        self.view.addSubview(languageView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReloadUserData), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LGSideMenuHideLeftViewAnimationsNotification"), object: nil)
    }
    
    //MARK:- Button Action

    @IBAction func showTerms(_ sender: UIButton) {
        
        let detailController  = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.TermsController) as! TermsController
        detailController.termsType = kTermsCondition
        let lgSideMenuController = sideMenuController
        if let rootController =  lgSideMenuController?.rootViewController as? DroTabBarController , let topController = rootController.selectedViewController {
            topController.navigationController?.pushViewController(detailController, animated: true)
            lgSideMenuController?.hideLeftViewAnimated()
        }
    }
    
    @IBAction func showPrivacy(_ sender: UIButton) {
        let detailController  = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.TermsController) as! TermsController
        detailController.termsType = kPrivcay
        let lgSideMenuController = sideMenuController
        if let rootController =  lgSideMenuController?.rootViewController as? DroTabBarController , let topController = rootController.selectedViewController {
            topController.navigationController?.pushViewController(detailController, animated: true)
            lgSideMenuController?.hideLeftViewAnimated()
        }
    }
    @IBAction func showProfile(_ sender: UIButton) {
        let detailController  = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.ProfileViewController) as! ProfileViewController        
        let lgSideMenuController = sideMenuController
        
        if let rootController =  lgSideMenuController?.rootViewController as? DroTabBarController , let topController = rootController.selectedViewController {
            topController.navigationController?.pushViewController(detailController, animated: true)
            lgSideMenuController?.hideLeftViewAnimated()
        }
        
    }
    @IBAction func showDisclaimer(_ sender: UIButton) {
        let detailController  = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.DetailTermViewController) as! DetailTermViewController
        detailController.titleString = kDisclaimer.localisedString()
        let lgSideMenuController = sideMenuController
        if let rootController =  lgSideMenuController?.rootViewController as? DroTabBarController , let topController = rootController.selectedViewController {
            topController.navigationController?.pushViewController(detailController, animated: true)
            lgSideMenuController?.hideLeftViewAnimated()
        }
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.languageView.center.x = self.languageView.bounds.width / 2
                        self.languageView.layoutIfNeeded()
        }, completion: nil)
        self.languageView.isHidden = false
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        let lgSideMenuController = sideMenuController
        let changePassword = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.ChangePassword) as! ChangePassword
        
        if let rootController =  lgSideMenuController?.rootViewController as? DroTabBarController , let topController = rootController.selectedViewController {
            topController.navigationController?.pushViewController(changePassword, animated: true)
            lgSideMenuController?.hideLeftViewAnimated()
        }
    }
    
    @IBAction func showLegalStatement(_ sender: UIButton) {
        let legalStatementController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.LegalStatementController) as! LegalStatementController
        
        let lgSideMenuController = sideMenuController
        if let rootController =  lgSideMenuController?.rootViewController as? DroTabBarController , let topController = rootController.selectedViewController {
            topController.navigationController?.pushViewController(legalStatementController, animated: true)
            lgSideMenuController?.hideLeftViewAnimated()
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
             let view = CustomLogoutAlert.instanceFromNib( title : kLogout.localisedString().capitalized , message: kLogout_Message.localisedString().capitalized  ) as? CustomLogoutAlert
            UIApplication.shared.keyWindow?.addSubview(view!)
        }else{
            let view = CustomLogoutAlert.instanceFromNib( title : kLogout.localisedString().capitalized  ,message: kLogout_Offline_Message.localisedString().capitalized ) as? CustomLogoutAlert
            UIApplication.shared.keyWindow?.addSubview(view!)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                       animations: {
                        self.languageView.center.x += self.languageView.bounds.width
                        self.languageView.layoutIfNeeded()
        },  completion: {(_ completed: Bool) -> Void in
            self.languageView.isHidden = true
        })
    }

    @objc func hideLanguageView(notifcation : Notification){
        if  !self.languageView.isHidden{
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                           animations: {
                            self.languageView.center.x += self.languageView.bounds.width
                            self.languageView.layoutIfNeeded()
                            
            },  completion: {(_ completed: Bool) -> Void in
                self.languageView.isHidden = true
            })
        }
    }
}

//MARK:- UITableViewDataSource

extension LeftViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.LanguageCell, for: indexPath)  as? LanguageCell
        cell?.labelLanguage.text = languageNameArray[indexPath.row].desc
        if languageNameArray[indexPath.row].code == selectedLanguageCode {
            cell?.imgSelected.isHidden = false
            cell?.labelLanguage.textColor = UIColor.appButtonColor

        }else{
            cell?.imgSelected.isHidden = true
            cell?.labelLanguage.textColor = UIColor.black
        }
        cell?.selectionStyle = .none
        return cell!
    }
}

//MARK:- UITableViewDelegate

extension LeftViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguageCode = languageNameArray[indexPath.row].code ?? "EN"
        kUserDefault.set(selectedLanguageCode, forKey: kselectedLanguage)
        changeLanguage()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
