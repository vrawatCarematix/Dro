//
//  ProfileViewController.swift
//  DROapp
//
//  Created by Carematix on 07/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var profileArray = [ProfileModel]()
    var titleArray = [String]()
    var removeTitle = ["FIRST_NAME" , "LAST_NAME" , "GENDER" , "ETHNICITY" , "IMAGE_UPLOAD"]
    var legalStatmentArray = [ConfigDatabaseModel]()
    
    @IBOutlet var profileTable: UITableView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userGender: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var buttonEdit: UIButton!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var scrollingHeaderView: UIView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        let currentTime = Int(Date().timeIntervalSince1970)

        if  CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            kUserDefault.set(currentTime, forKey: kLastProfileRefresh)
            getUserData()
        }else{
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Pull to refesh
        self.profileTable.addSubview(self.refreshControl)
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.attributedTitle =  NSAttributedString(string: kRefreshing.localisedString().capitalized + "..." , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ,NSAttributedString.Key.font: UIFont(name: kSFSemibold, size:labelTitle.font.pointSize - 2 )!])
        
       // self.profileTable.contentInset = UIEdgeInsets.init(top: CGFloat(self.view.getCustomFontSize(size: 10) * 22) , left: 0, bottom: 0, right: 0)
        legalStatmentArray = DatabaseHandler.getAllConfig(kPersonalDetails)
        self.profileTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        initialiseData()
        setText()
       // self.scrollingHeaderView.frame = CGRect(x: 0, y: self.profileTable.frame.origin.y, width: UIScreen.main.bounds.size.width, height: CGFloat(self.view.getCustomFontSize(size: 10) * 22))
        self.scrollingHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(self.view.getCustomFontSize(size: 10) * 22))

        self.profileTable.tableHeaderView = scrollingHeaderView
    //    self.view.addSubview(self.scrollingHeaderView)
        labelTitle.text = kProfile.localisedString()
        buttonEdit.setTitle(kEdit.localisedString(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
           // self.scrollingHeaderView.frame = CGRect(x: 0, y: self.profileTable.frame.origin.y, width: UIScreen.main.bounds.size.width, height: CGFloat(self.view.getCustomFontSize(size: 10) * 22))
            self.scrollingHeaderView.clipsToBounds = true
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
            self.profileImage.clipsToBounds = true
        }
        
        let currentTime = Int(Date().timeIntervalSince1970)
        if let refreshDate = kUserDefault.value(forKey: kLastProfileRefresh) as? Int ,   ( refreshDate + 5 * 60 ) < currentTime {
            if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
                kUserDefault.set(currentTime, forKey: kLastProfileRefresh)
                CustomActivityIndicator.startAnimating( message: kLoading.localisedString() + "...")
                getUserData()
            }else{
                if let profileData = kUserDefault.value(forKey: kProfileData) as? Data  {
                    do {
                        if  let dictonary = try JSONSerialization.jsonObject(with: profileData, options: []) as? [[String :Any]]{
                            self.parseProfileData(response: dictonary)
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        }else{
            if let profileData = kUserDefault.value(forKey: kProfileData) as? Data {
                do {
                    if  let dictonary = try JSONSerialization.jsonObject(with: profileData, options: []) as? [[String :Any]]{
                        if let _ = kUserDefault.value(forKey: kLastProfileRefresh) as? Int  {
                        }else{
                            kUserDefault.set(currentTime, forKey: kLastProfileRefresh)
                        }
                        self.parseProfileData(response: dictonary)
                    }
                } catch let error as NSError {
                    debugPrint(error)
                }
            }else{
                if  CheckNetworkUsability.sharedInstance().checkInternetConnection() {
                    kUserDefault.set(currentTime, forKey: kLastProfileRefresh)
                    CustomActivityIndicator.startAnimating( message: kLoading.localisedString() + "...")
                    getUserData()
                }
            }
        }
    }
    
    func getUserData() {
        getProfileData { (success, response, message) in
            DispatchQueue.main.async {
                // print(response)
                CustomActivityIndicator.stopAnimating()
                if success {
                    self.parseProfileData(response: response)
                }
                else{
                    self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                }
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func setText()  {
        if let firstName = kUserDefault.value(forKey: kfirstName) as? String {
            if let lastName = kUserDefault.value(forKey: klastName) as? String {
                userName.text = firstName + " " + lastName
            }else{
                userName.text = firstName
            }
        }else{
            userName.text = ""
        }
        if let userImage = kUserDefault.value(forKey: kProflieImage) as? String {
            if let dataDecoded = Data(base64Encoded: userImage, options: Data.Base64DecodingOptions(rawValue: NSData.Base64DecodingOptions.RawValue(0))){
                if let image =  UIImage(data: dataDecoded){
                    self.profileImage.image = image
                    self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
                }
            }
            
        }
    }
    
    func parseProfileData( response : [[String : Any]])  {
        self.profileArray.removeAll()
        for profileData in response{
            let profileModel = ProfileModel(jsonObject: profileData)
            self.profileArray.append(profileModel)
        }
        self.titleArray.removeAll()
        self.titleArray = self.profileArray.compactMap({ $0.fieldType})
        for title in self.removeTitle {
            if let index = self.titleArray.index(of: title) {
                self.titleArray.remove(at: index)
            }
        }
        
        if self.profileArray.filter({ $0.fieldType == "FIRST_NAME" }).count > 0 , let firstName = self.profileArray.filter({ $0.fieldType == "FIRST_NAME" })[0].value {
            if self.profileArray.filter({ $0.fieldType == "LAST_NAME" }).count > 0 , let lastName = self.profileArray.filter({ $0.fieldType == "LAST_NAME" })[0].value {
                self.userName.text = firstName + " " + lastName
            }else{
                self.userName.text = firstName
            }
        }else{
            self.userName.text = ""
        }
        
        if self.profileArray.filter({ $0.fieldType == "GENDER" }).count > 0 , let gender = self.profileArray.filter({ $0.fieldType == "GENDER" })[0].value , gender.trimmingCharacters(in: .whitespacesAndNewlines ) != "" {
            if self.profileArray.filter({ $0.fieldType == "ETHNICITY" }).count > 0 , let ethnticity = self.profileArray.filter({ $0.fieldType == "ETHNICITY" })[0].value  , ethnticity.trimmingCharacters(in: .whitespacesAndNewlines ) != ""{
                self.userGender.text = gender + ", " + ethnticity.capitalized
            }else{
                self.userGender.text = gender
            }
        }else{
            if self.profileArray.filter({ $0.fieldType == "ETHNICITY" }).count > 0 , let ethnticity = self.profileArray.filter({ $0.fieldType == "ETHNICITY" })[0].value ,  ethnticity.trimmingCharacters(in: .whitespacesAndNewlines ) != ""{
                self.userGender.text =  ethnticity.capitalized
            }else{
                self.userGender.text = ""
            }
        }
        
        if self.profileArray.filter({ $0.fieldType == "IMAGE_UPLOAD" }).count > 0 , let imageBase64 = self.profileArray.filter({ $0.fieldType == "IMAGE_UPLOAD" })[0].value {
            
            if let dataDecoded = Data(base64Encoded: imageBase64, options: Data.Base64DecodingOptions(rawValue: NSData.Base64DecodingOptions.RawValue(0))){
                if let image =  UIImage(data: dataDecoded){
                    self.profileImage.image = image
                    kUserDefault.set(imageBase64, forKey: kProflieImage)
                    self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2

                }
            }
        }
        self.profileTable.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.profileTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if newSize.height > (self.profileTable.frame.size.height - CGFloat(self.view.getCustomFontSize(size: 10) * 22) ){
                        self.profileTable.isScrollEnabled = true
                    }else{
                        self.profileTable.isScrollEnabled = false
                    }
                }
            }
        }
    }
    func initialiseData()  {
        labelTitle.setCustomFont()
        buttonEdit.setCustomFont()
        userName.setCustomFont()
        userGender.setCustomFont()
    }
   
    
    @IBAction func editUserData(_ sender: UIButton) {
        
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            let detailController  = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.EditProfileController) as! EditProfileController
            detailController.profileArray = self.profileArray
            self.navigationController?.pushViewController(detailController, animated: true)
        }else{
            self.view.showToast(toastMessage: "You cannot change your person detail in offline mode", duration: 1.1)
        }
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension ProfileViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.ProfileTableViewCell, for: indexPath)  as? ProfileTableViewCell
        let titleType = titleArray[indexPath.row]
        let defaultValuesArray = self.legalStatmentArray.filter({ $0.fieldType == titleType })
        let profileDataArray = self.profileArray.filter({ $0.fieldType == titleType })
        if defaultValuesArray.count > 0 && profileDataArray.count > 0{
            let defaultValue = defaultValuesArray[0]
            let profileData = profileDataArray[0]
            cell?.labelTitle.text = defaultValue.text?.capitalized
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            if let text = profileData.value?.trimmingCharacters(in: .whitespacesAndNewlines), let date = formatter.date(from: (text)){
                formatter.dateFormat = "MMMM dd, yyyy"
                cell?.labelData.text = formatter.string(from:date)
            }else if defaultValue.componentType == kComponentCheckBox{
                var values = [String]()
                for value in defaultValue.valuesArray{
                    if let valueString = profileData.value , valueString.contains(value){
                        values.append(" " + value)
                    }
                }
                if values.count == 0 {
                    profileData.value = " "
                }else{
                    profileData.value = values.joined(separator: ",")
                    cell?.labelData.text = profileData.value?.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }else{
                cell?.labelData.text = profileData.value
            }
        }
        cell?.selectionStyle = .none
        return cell!
    }
}

extension ProfileViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y =  -scrollView.contentOffset.y
//        var height = min(max(y, userGender.frame.size.height +  userGender.frame.origin.y + 30 - profileImage.frame.origin.y), CGFloat(self.view.getCustomFontSize(size: 10) * 22) + 50)
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            height = min(max(y, userGender.frame.size.height +  userGender.frame.origin.y + 80 - profileImage.frame.origin.y), CGFloat(self.view.getCustomFontSize(size: 10) * 22) + 50)
//        }
//        scrollingHeaderView.frame =  CGRect(x: 0, y: self.profileTable.frame.origin.y, width: UIScreen.main.bounds.size.width, height: height)
//    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        print(translation.y)
//        if translation.y > 2 {
//            print("down")
//            // swipes from top to bottom of screen -> down
//        } else {
//            print("up")
//
//            // swipes from bottom to top of screen -> up
//        }
//    }
    
}

