//
//  EditProfileController.swift
//  DROapp
//
//  Created by Carematix on 07/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Crashlytics

class EditProfileController: UIViewController {

    //Variables
    var titleArray = [String]()
    var typeArray = ["User Name" , "text" , "text" , "date" , "Ethnicity" , "textview" ]
    var profileArray = [ProfileModel]()
    var removeTitle = [ "LAST_NAME" , "IMAGE_UPLOAD"]
    var countArray = [Int]()
    var legalStatmentArray = [ConfigDatabaseModel]()

    //Outlet

    @IBOutlet var profileTable: UITableView!
    @IBOutlet var buttonDone: UIButton!
    @IBOutlet var labelTitle: UILabel!
    
    
    //Mark:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.setCustomFont()
        buttonDone.setCustomFont()
        legalStatmentArray = DatabaseHandler.getAllConfig(kPersonalDetails)
        profileTable.allowsSelection = true

        self.titleArray = self.profileArray.compactMap({ $0.fieldType})
        for title in self.removeTitle {
            if let index = self.titleArray.index(of: title) {
                self.titleArray.remove(at: index)
            }
        }
        
        self.profileTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        let dropdownSingleSelectionNib = UINib(nibName: ReusableIdentifier.DropdownSingleSelectionCell, bundle: nil)
        profileTable.register(dropdownSingleSelectionNib, forCellReuseIdentifier: ReusableIdentifier.DropdownSingleSelectionCell)
        let dropdownMultiSelectionNib = UINib(nibName: ReusableIdentifier.DropdownMultiSelectionCell, bundle: nil)
        profileTable.register(dropdownMultiSelectionNib, forCellReuseIdentifier: ReusableIdentifier.DropdownMultiSelectionCell)
        // Do any additional setup after loading the view.
        settext()
    }

    
    func settext()  {
        labelTitle.text = kEditProfile.localisedString()
        buttonDone.setTitle(kDone.localisedString(), for: .normal)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.profileTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if newSize.height > (self.profileTable.frame.size.height){
                        self.profileTable.isScrollEnabled = true
                    }else{
                        self.profileTable.isScrollEnabled = false
                    }
                }
            }
        }
    }


    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        self.view.endEditing(true)
        saveProfileData()
    }
    
    func saveProfileData() {

        CustomActivityIndicator.startAnimating( message: kUpdating.localisedString() + "...")
        WebServiceMethods.sharedInstance.saveProfileData(profileArray){ (success, response, message) in
            DispatchQueue.main.async {
                print(response)
                CustomActivityIndicator.stopAnimating()
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kReloadUserData), object: nil)

                     self.navigationController?.popViewController(animated: true)
                }
                else{
                    self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                }
            }
        }
    }

}

extension EditProfileController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  countArray.contains(section){
            let titleType = titleArray[section]
            let defaultValue = legalStatmentArray.filter({ $0.fieldType == titleType })
            if defaultValue.count > 0 {
                return defaultValue[0].valuesArray.count + 1
            }else{
                return 1
            }
        }else{
            return 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count

    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.allowsSelection = true
        let titleType = titleArray[indexPath.section]

        let defaultValuesArray = self.legalStatmentArray.filter({ $0.fieldType == titleType })
        let profileDataArray = self.profileArray.filter({ $0.fieldType == titleType })
        if defaultValuesArray.count > 0 && profileDataArray.count > 0{
            let defaultValue = defaultValuesArray[0]
            let profileData = profileDataArray[0]
            
            if indexPath.row > 0 {
                if defaultValue.componentType == kComponentCheckBox{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DropdownMultiSelectionCell, for: indexPath)  as? DropdownMultiSelectionCell
                        cell?.labelData.text =   defaultValue.valuesArray[indexPath.row - 1]
                    if (profileData.value?.lowercased().contains(defaultValue.valuesArray[indexPath.row - 1].lowercased()))!  {
                        cell?.imgSelection.image = #imageLiteral(resourceName: "tickOptionOn")
                    }else{
                        cell?.imgSelection.image = #imageLiteral(resourceName: "tickOptionOff")
                    }
                    cell?.selectionStyle = .none
                    return cell!
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DropdownSingleSelectionCell, for: indexPath)  as? DropdownSingleSelectionCell
                    
                        cell?.labelData.text =                     defaultValue.valuesArray[indexPath.row - 1]
                    
                    if cell?.labelData.text?.lowercased() == profileData.value?.lowercased() {
                        cell?.imgSelection.image = #imageLiteral(resourceName: "radioOptionOn")
                    }else{
                        cell?.imgSelection.image = #imageLiteral(resourceName: "radioOptionOff")
                    }
                    cell?.selectionStyle = .none
                    return cell!
                }
            }
            
            if titleType  == "FIRST_NAME" {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.EditProfileNameCell, for: indexPath)  as? EditProfileNameCell
                cell?.labelUsername.text = "FIRST_NAME".replacingOccurrences(of: "_", with: " ").capitalized
                cell?.labelLastName.text = "LAST_NAME".replacingOccurrences(of: "_", with: " ").capitalized
                
                let defaultValue = legalStatmentArray.filter({ $0.fieldType == "FIRST_NAME" })
                if defaultValue.count > 0{
                    cell?.textfieldFirstName.placeholder = defaultValue[0].placeHolder
                }
                cell?.textfieldFirstName.delegate = self
                cell?.textfieldLastName.delegate = self
                cell?.delegate = self
                if self.profileArray.filter({ $0.fieldType == "FIRST_NAME" }).count > 0 , let firstName = self.profileArray.filter({ $0.fieldType == "FIRST_NAME" })[0].value {
                    cell?.textfieldFirstName.text = firstName
                    
                }else{
                    cell?.textfieldFirstName.text = ""
                }
                
                let defaultValue1 = legalStatmentArray.filter({ $0.fieldType == "LAST_NAME" })
                if defaultValue1.count > 0{
                    cell?.textfieldLastName.placeholder = defaultValue1[0].placeHolder
                }
                if self.profileArray.filter({ $0.fieldType == "LAST_NAME" }).count > 0 , let lastName = self.profileArray.filter({ $0.fieldType == "LAST_NAME" })[0].value {
                    cell?.textfieldLastName.text = lastName
                    
                }else{
                    cell?.textfieldLastName.text = ""
                }
               
                if self.profileArray.filter({ $0.fieldType == "IMAGE_UPLOAD" }).count > 0 , let imageBase64 = self.profileArray.filter({ $0.fieldType == "IMAGE_UPLOAD" })[0].value {
                    if let dataDecoded = Data(base64Encoded: imageBase64, options: Data.Base64DecodingOptions(rawValue: NSData.Base64DecodingOptions.RawValue(0))){
                        let selectedImageSize:Int = dataDecoded.count
                        print("Image Size: %f KB", selectedImageSize / 1024)
                        if let image =  UIImage(data: dataDecoded){
                            cell?.imgProfile.image = image
                        }
                    }
                }else{
                    //self.userGender.text = ""
                }
                cell?.selectionStyle = .none
                return cell!
            }else if defaultValue.componentType == kComponentTextBox || defaultValue.componentType == kComponentNumeric {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.EditProfileTextCell, for: indexPath)  as? EditProfileTextCell
                cell?.textfieldData.placeholder = defaultValue.placeHolder
                cell?.labelTitle.text = defaultValue.text?.replacingOccurrences(of: "_", with: " ").capitalized
                cell?.textfieldData.text = profileData.value
                if defaultValue.componentType == kComponentNumeric {
                    cell?.textfieldData.keyboardType = .numberPad
                }else{
                    cell?.textfieldData.keyboardType = .default
                }
                cell?.textfieldData.delegate = self
                cell?.selectionStyle = .none
                return cell!
            }else if defaultValue.componentType  == kComponentDate {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.EditProfileDateCell, for: indexPath)  as? EditProfileDateCell
                cell?.delegate = self
                cell?.labelTitle.text = defaultValue.text?.replacingOccurrences(of: "_", with: " ").capitalized
                cell?.textfieldData.placeholder = defaultValue.placeHolder
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd,yyyy"
                if let text = profileData.value?.trimmingCharacters(in: .whitespacesAndNewlines), let date = formatter.date(from: (text)){
                    formatter.dateFormat = "MMMM dd, yyyy"
                    cell?.textfieldData.text = formatter.string(from:date)
                }else{
                    cell?.textfieldData.text = profileData.value
                }
                cell?.selectionStyle = .none
                return cell!
            }else if titleType  == "ABOUT"  {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.EditProfileTextViewCell, for: indexPath)  as? EditProfileTextViewCell
                cell?.delegate = self
              
                cell?.textViewData.tag = indexPath.row
                cell?.selectionStyle = .none
                return cell!
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.EditProfileDropdownCell, for: indexPath)  as? EditProfileDropdownCell
                cell?.labelTitle.text = titleType.replacingOccurrences(of: "_", with: " ").capitalized
                if let _ = countArray.index(of: (indexPath.section)){
                        cell?.imgArrow.transform = CGAffineTransform(rotationAngle: .pi)
                }else{
                    cell?.imgArrow.transform =  CGAffineTransform.identity
                }
                cell?.delegate = self
                cell?.labelData.text = profileData.value
                cell?.selectionStyle = .none
                return cell!
            }
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        return cell!

        
    }
}

extension EditProfileController : UITableViewDelegate{
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0{
            let titleType = titleArray[indexPath.section]
            let defaultValue = self.legalStatmentArray.filter({ $0.fieldType == titleType })[0]
            let profileData = self.profileArray.filter({ $0.fieldType == titleType })[0]

            if defaultValue.componentType == kComponentCheckBox{
                let cell = tableView.cellForRow(at: indexPath) as? DropdownMultiSelectionCell
                if  (profileData.value?.lowercased().contains(defaultValue.valuesArray[indexPath.row - 1].lowercased()))!  {
                    cell?.imgSelection.image = #imageLiteral(resourceName: "tickOptionOff")

                }else{
                    cell?.imgSelection.image = #imageLiteral(resourceName: "tickOptionOn")
                }
                var values = [String]()
                for i in 1...defaultValue.valuesArray.count {
                    if let cell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section )) as? DropdownMultiSelectionCell {
                        if cell.imgSelection.image == #imageLiteral(resourceName: "tickOptionOn") {
                            values.append(defaultValue.valuesArray[i - 1])
                        }
                    }
                }
                if values.count == 0 {
                    profileData.value = " "
                }else{
                    profileData.value = values.joined(separator: ",")
                }
            }else{
                profileData.value = defaultValue.valuesArray[indexPath.row - 1]
            }
            profileTable.beginUpdates()
            profileTable.reloadSections([indexPath.section], with: .automatic)
            profileTable.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.1//UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 1.1
    }
}

extension EditProfileController : EditProfileNameCellDelegate{
    
    func saveImageData(data: Data, cell: EditProfileNameCell) {
        let profileData = self.profileArray.filter({ $0.fieldType == "IMAGE_UPLOAD" })[0]
        profileData.value = data.base64EncodedString()
    }

}

extension EditProfileController : EditProfileDateCellDelegate{
    
    func saveDate(date: String, cell: EditProfileDateCell) {
        let indexPath = profileTable.indexPath(for: cell)
        let titleType = titleArray[(indexPath?.section)!]
        let profileData = self.profileArray.filter({ $0.fieldType == titleType })[0]
        profileData.value = date
    }
    
}

extension EditProfileController :UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = textField.superview?.superview as? EditProfileTextCell  {
            let indexPath = profileTable.indexPath(for: cell)
            let titleType = titleArray[(indexPath?.section)!]
            let profileData = self.profileArray.filter({ $0.fieldType == titleType })[0]
            
            if let text =  textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) , text != ""{
                profileData.value = text
            }else{
                profileData.value = " "

            }
 
        }else  if let cell = textField.superview?.superview as? EditProfileNameCell {
            let profileData = self.profileArray.filter({ $0.fieldType == "FIRST_NAME" })[0]
            profileData.value = cell.textfieldFirstName.text
            
            let profileData1 = self.profileArray.filter({ $0.fieldType == "LAST_NAME" })[0]
            profileData1.value = cell.textfieldLastName.text
     
        }
       
    }
}

extension EditProfileController :EditProfileTextViewCellDelegate {
    func textViewDidChange(_ textView: UITextView, height: CGFloat) {
        IQKeyboardManager.shared.reloadLayoutIfNeeded()

       profileTable.beginUpdates()
       //let cell = profileTable.cellForRow(at: IndexPath(row: textView.tag, section: 0)) as? EditProfileTextViewCell
        //cell?.textViewHeight.constant = textView.contentSize.height

       // cell?.textViewData.becomeFirstResponder()
       // profileTable.reloadRows(at: [IndexPath(row: textView.tag, section: 0)], with: .automatic)
        profileTable.endUpdates()


    }
}
extension EditProfileController :EditProfileDropdownCellDelegate{
    func clickedOnButton(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? EditProfileDropdownCell else {
            return // or fatalError() or whatever
        }
        let indexPath = profileTable.indexPath(for: cell)
        
        if let index = countArray.index(of: (indexPath?.section)!){
            countArray.remove(at: index)
        }else{
            countArray.append((indexPath?.section)!)
        }
        profileTable.beginUpdates()
        profileTable.reloadSections([(indexPath?.section)!], with: .automatic)
        profileTable.endUpdates()
        if let _ = countArray.index(of: (indexPath?.section)!){
             profileTable.scrollToRow(at: indexPath!, at: .top, animated: true)
        }
        
    }
}
