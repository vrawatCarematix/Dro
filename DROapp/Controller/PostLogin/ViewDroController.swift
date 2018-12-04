//
//  ViewDroController.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.

import UIKit

class ViewDroController: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var navView: UIView!
    @IBOutlet var cancelButtonTrailingConstrient: NSLayoutConstraint!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var droTable: UITableView!
    
    //MARK:- Variables

    var tableY = CGFloat(0)
    var filteredDroInfoListModelArray = [SurveyScheduleDatabaseModel]()
    var droInfoListModelArray = [SurveyScheduleDatabaseModel]()

    //MARK:- View Life Cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.setCustomFont()
        if UIDevice.current.userInterfaceIdiom == .pad {
            searchView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 30 / 320)
        }else{
            searchView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 50 / 320)
        }
        searchView.backgroundColor = UIColor(red: 34.0/255.0, green: 39.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        searchTextField.backgroundColor = UIColor(red:0.2353, green: 0.2510, blue: 0.2824, alpha: 1.0)
        searchTextField.attributedPlaceholder = NSAttributedString(string: kSearch.localisedString() , attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0.8, alpha: 0.8)])

        cancelButton.setCustomFont()
        searchTextField.setCustomFont()
        self.cancelButton.isHidden = true

        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 25))
        let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 25, height: 25))
        imageView.image = #imageLiteral(resourceName: "searchIcon")
        rightView.addSubview(imageView)
        
        searchTextField.leftView = rightView
        searchTextField.leftViewMode = .always
        
        self.searchTextField.layer.cornerRadius = 20 * (UIScreen.main.bounds.size.width - 60) / 964
         droTable.tableHeaderView = searchView
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewDroData), name: NSNotification.Name(rawValue: kReloadViewDroData) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
          setText()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tableY == 0 {
            tableY = droTable.frame.origin.y
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReloadViewDroData), object: nil)
    }
    
    @objc func setText(){
        labelTitle.text = kView_DROs.localisedString()
        getViewDroData()
    }
    
    @objc func reloadViewDroData(){
        
        droInfoListModelArray.removeAll()
        filteredDroInfoListModelArray.removeAll()
        
        var query = ""
        if let droStatus = kUserDefault.value(forKey: kDroStatus) as? [String]{
            
            if let status = droStatus.first , status.lowercased() == "All".lowercased(){
                query += " ( progressStatus == 'EXPIRED' OR progressStatus == 'COMPLETED' OR progressStatus == 'DECLINED' OR isDeclined = 1 )  "
            }else{
                for status in droStatus {
                    if query == "" {
                        query += " ( progressStatus = '" + status + "' "
                    }else{
                        query += " OR progressStatus = '" + status + "' "
                    }
                    if query.contains("DECLINED"){
                        query += " OR isDeclined = 1 "
                    }
                }
                query += " ) "
            }
        }else{
            query += " ( progressStatus == 'EXPIRED' OR progressStatus == 'COMPLETED' OR progressStatus == 'DECLINED' OR isDeclined = 1 )  "
        }
        if let droSort = kUserDefault.value(forKey: kDroSort) as? String{
            if droSort == kDroAsc {
               query += " ORDER BY actualEndTime ASC "
            }else if droSort == kDroDsc {
               query += " ORDER BY actualEndTime DESC "
            }else {
                query += " ORDER BY actualEndTime ASC "
            }
        }else{
           query += " ORDER BY actualEndTime DESC "
        }
        var startTime = Int(Date().timeIntervalSince1970)
        startTime  += TimeZone.current.secondsFromGMT()
        droInfoListModelArray = DatabaseHandler.getViewDro(startTime: Int(startTime * 1000), query: query, count: 90)
        filteredDroInfoListModelArray = droInfoListModelArray
        droTable.reloadData()
    }

    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height) 
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5.0)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        path.fill()
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    @objc func getViewDroData() {
        reloadViewDroData()
    }
   
    //MARK:- Button Action

    @IBAction func showFilter(_ sender: UIButton) {
        let filterController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.FilterDroController) as? FilterDroController
        self.present(filterController!, animated: true, completion: nil)
    }
    
    @IBAction func cancelSearch(_ sender: UIButton) {
        searchTextField.text = ""
        filteredDroInfoListModelArray = droInfoListModelArray
        droTable.reloadData()
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if sender.text?.count == 0 {
            filteredDroInfoListModelArray = droInfoListModelArray
        }else{
            filteredDroInfoListModelArray = droInfoListModelArray.filter({
                ($0.surveyName?.lowercased().contains(sender.text!.lowercased()))!
            })
        }
        droTable.reloadData()
    }
}

//MARK:- UITableViewDataSource

extension ViewDroController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDroInfoListModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.ViewDroListCell) as? ViewDroListCell
        let dro = filteredDroInfoListModelArray[indexPath.row]
        cell?.labelDroName.text = dro.surveyName
        if let endTime = dro.actualEndTime {
            let localDate = Date(timeIntervalSince1970: TimeInterval(endTime / 1000) )
            let dateFormatter = DateFormatter()
            if let selectedLanguageCode = kUserDefault.value(forKey: kselectedLanguage) as? String {
                dateFormatter.locale = Locale(identifier: selectedLanguageCode)
            }else{
                dateFormatter.locale = Locale(identifier: "EN")
            }
            dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
            let dateString = dateFormatter.string(from: localDate)
         
            cell?.labelDueBy.text = dateString
        }else{
            cell?.labelDueBy.text = " "
        }
        if let programName = kUserDefault.value(forKey: kprogramName) as? String {
            cell?.labelDroType.text = programName
        }else{
            cell?.labelDroType.text = ""
        }
        
        if let isDeclined = dro.isDeclined , isDeclined == 1 {
            cell?.labelDroStatus.text = kDeclined.localisedString().capitalized
            cell?.imgStatus.image = #imageLiteral(resourceName: "declined")
        }else{
            if let progressStatus = dro.progressStatus {
                if progressStatus == "NOT_STARTED"  {
                    cell?.labelDroStatus.text = kStart.localisedString().capitalized
                    cell?.imgStatus.image = #imageLiteral(resourceName: "assigned")
                }else if progressStatus.lowercased() == "Continue".lowercased(){                    
                    cell?.labelDroStatus.text = kContinue.localisedString().capitalized
                    cell?.imgStatus.image = #imageLiteral(resourceName: "activated")
                }else if progressStatus.lowercased() == "EXPIRED".lowercased(){
                    cell?.labelDroStatus.text = kExpired.localisedString().capitalized
                    cell?.imgStatus.image = #imageLiteral(resourceName: "expired")
                }else{
                    cell?.labelDroStatus.text = progressStatus.capitalized.localisedString()
                    cell?.imgStatus.image = #imageLiteral(resourceName: "completedDash")
                }
            }else{
                cell?.labelDroStatus.text = ""
                cell?.imgStatus.image = nil
            }
        }
        cell?.selectionStyle = .none

        return cell!
    }
}

//MARK:- UITableViewDelegate

extension ViewDroController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.ViewDroHeaderCell) as? ViewDroHeaderCell
        cell?.configCell()
        cell?.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

// MARK: - UITextFieldDelegate

extension ViewDroController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var rect = droTable.frame
        if UIDevice.current.userInterfaceIdiom == .pad {
            rect.origin.y = 40
        }else{
            rect.origin.y = 20
        }
        rect.size.height = rect.size.height + navView.frame.size.height + navView.frame.origin.y
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseIn],
                       animations: {
                        self.cancelButton.isHidden = false
                        self.droTable.frame = rect
                        self.cancelButtonTrailingConstrient.constant = 15
        }, completion: { (success) in
            self.cancelButton.isHidden = false
        })
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseIn],
                       animations: {
                        var rect = self.droTable.frame
                        rect.origin.y = self.navView.frame.size.height + self.navView.frame.origin.y
                        rect.size.height = rect.size.height - self.navView.frame.size.height -  self.navView.frame.origin.y
                        self.droTable.frame = rect
                        self.cancelButtonTrailingConstrient.constant = -self.cancelButton.frame.size.width
                        self.cancelButton.isHidden = true
        }, completion: { (success) in
            self.cancelButton.isHidden = true
        })
        return true
    }
    
}
