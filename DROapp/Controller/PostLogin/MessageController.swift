//
//  MessageController.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit



class MessageController: DROViewController {
    
    //MARK:- Outlets

    @IBOutlet var labelNoMessage: UILabel!
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var navView: UIView!
    @IBOutlet var cancelButtonTrailingConstrient: NSLayoutConstraint!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var labelTitle: UILabel!
        @IBOutlet var messageTable: UITableView!
    
    //MARK:- Variables

    var tableY = CGFloat(0)
    var messageArray = [MessageModel]()
    var filteredMessageArray = [MessageModel]()
    let searchController = UISearchController(searchResultsController: nil)

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        labelNoMessage.isHidden = true

        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            getMessageFromServer()
        }else{
            setText()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    
    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.setCustomFont()
        self.navigationController?.navigationBar.tintColor = UIColor.white
       self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
       if UIDevice.current.userInterfaceIdiom == .pad {
            searchView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 30 / 320)
        }else{
            searchView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 50 / 320)
        }
        searchView.backgroundColor = UIColor(red: 34.0/255.0, green: 39.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        searchTextField.backgroundColor = UIColor(red:0.2353, green: 0.2510, blue: 0.2824, alpha: 1.0)
        
        cancelButton.setCustomFont()
        searchTextField.setCustomFont()
        self.cancelButton.isHidden = true
        
        //Pull to refesh
        self.messageTable.addSubview(self.refreshControl)
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.attributedTitle =  NSAttributedString(string: kRefreshing.localisedString().capitalized + "..." , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ,NSAttributedString.Key.font: UIFont(name: kSFSemibold, size:labelTitle.font.pointSize - 2 )!])
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: kSearch.localisedString().capitalized, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0.8, alpha: 0.8)])
        searchTextField.textColor = .white
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 25))
        let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 25, height: 25))
        imageView.image = #imageLiteral(resourceName: "searchIcon")
        rightView.addSubview(imageView)
        
        searchTextField.leftView = rightView
        searchTextField.leftViewMode = .always
        
        self.searchTextField.layer.cornerRadius = 20 * (UIScreen.main.bounds.size.width - 60) / 964
        messageTable.tableHeaderView = searchView
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewDroData), name: NSNotification.Name(rawValue: kReloadMessageData) , object: nil)
        setText()
    }
    
    //MARK:- Changes Text on language Changes
    
    @objc func setText()  {
        labelTitle.text = kMessages.localisedString().capitalized
        let count = DatabaseHandler.getUnreadMessageCount()
        if count == 0 {
            self.tabBarController?.tabBar.items?[3].badgeValue = nil
        }else{
            self.tabBarController?.tabBar.items?[3].badgeValue = "\(count)"
        }
        reloadViewDroData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReloadMessageData), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setText()
        let currentTime = Int(Date().timeIntervalSince1970)
        
        if let _ = kUserDefault.value(forKey: kLastMessageRefresh) as? Int  {
        }else{
            if CheckNetworkUsability.sharedInstance().checkInternetConnection()  {
                CustomActivityIndicator.startAnimating(message: kLoading.localisedString().capitalized + "...")
                getMessageFromServer()
                kUserDefault.set(currentTime, forKey: kLastMessageRefresh)
            }
            
        }
        if let refreshDate = kUserDefault.value(forKey: kLastMessageRefresh) as? Int ,   ( refreshDate + 5 * 60 ) < currentTime , CheckNetworkUsability.sharedInstance().checkInternetConnection()  {
                CustomActivityIndicator.startAnimating(message: kLoading.localisedString().capitalized + "...")
                getMessageFromServer()
                kUserDefault.set(currentTime, forKey: kLastMessageRefresh)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor =  UIColor(red:0.2353, green: 0.2510, blue: 0.2824, alpha: 1.0)
        
        textFieldInsideSearchBar?.textColor = .white
        if tableY == 0 {
            tableY = messageTable.frame.origin.y
        }
    }
    
    @objc func reloadViewDroData(){
        messageArray.removeAll()
        filteredMessageArray.removeAll()
        var query = ""
        if let droStatus = kUserDefault.value(forKey: kMessageStatus) as? [String]{
            if let status = droStatus.first , status.lowercased() == "All".lowercased(){
                query += " ( readStatus == 'READ' OR readStatus == 'UNREAD' OR readStatus == 'STARRED' OR isStarred = 1 )  "
            }else{
                for status in droStatus {
                    if query == "" {
                        query += " ( readStatus = '" + status + "' "
                    }else{
                        query += " OR readStatus = '" + status + "' "
                    }
                    if query.contains("STARED"){
                        query += " OR isStarred = 1 "
                    }
                }
                query += " ) "
            }
        }else{
            query += " ( readStatus == 'READ' OR readStatus == 'UNREAD' OR readStatus == 'STARRED' OR isStarred = 1 )  "
        }
        if let droSort = kUserDefault.value(forKey: kMessageSort) as? String{
            if droSort == kDroAsc {
                query += " ORDER BY createTime ASC "
            }else if droSort == kDroDsc {
                query += " ORDER BY createTime DESC "
            }else {
                query += " ORDER BY senderName ASC "
            }
        }else{
            query += " ORDER BY createTime DESC "
        }
        self.messageArray.removeAll()
        self.messageArray = DatabaseHandler.getAllMessage(query, count: 30)
        filteredMessageArray = messageArray
        if messageArray.count  == 0{
            labelNoMessage.isHidden = false
        }else{
            labelNoMessage.isHidden = true

        }
        messageTable.reloadData()
    }
   
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    @IBAction func filter(_ sender: UIButton) {
        let filterController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.FilterMessageController) as? FilterMessageController
        self.present(filterController!, animated: true, completion: nil)
    }
    
    @IBAction func cancelSearch(_ sender: UIButton) {
        searchTextField.text = ""
        filteredMessageArray = messageArray
        messageTable.reloadData()
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if sender.text?.count == 0 {
            filteredMessageArray = messageArray
        }else{
            filteredMessageArray = messageArray.filter({
                ($0.senderName?.lowercased().contains(sender.text!.lowercased()))!
            })
        }
        messageTable.reloadData()
    }
    
    func getMessageFromServer(){
        getMessage { (success, response, message) in
            DispatchQueue.main.async {
                CustomActivityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                if success {
                    self.setText()
                }else{
                  //  self.showErrorAlert(titleString: kAlert.localisedString(), message: kNo_Message_Found.localisedString())
                }
                self.setText()

            }
        }
    }

}

//MARK:- UITableViewDataSource
extension MessageController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return filteredMessageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.MessageTableCell) as? MessageTableCell
        cell?.selectionStyle = .none
        let messageModel = filteredMessageArray[indexPath.row]
        if let senderName = messageModel.senderName{
            cell?.labelName.text = senderName
        }
        if let textMessage = messageModel.textMessage{
            cell?.labelMessage.text = textMessage.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let createTime = messageModel.createTime{
            var selectedLocale = "En"
            if let selectedLanguageCode = kUserDefault.value(forKey: kselectedLanguage) as? String {
                selectedLocale = selectedLanguageCode
            }
            let date = Date(timeIntervalSince1970: TimeInterval((createTime) / 1000))
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd MM yy"
            let dateString = dateFormatter2.string(from: Date())
            let todayDate = dateFormatter2.date(from: dateString)
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: todayDate!)!
            if date < yesterday {
                let dateFormatter3 = DateFormatter()
                dateFormatter3.locale = Locale(identifier: selectedLocale)
                dateFormatter3.dateFormat = "MMMM dd "
                cell?.labelDate.text = dateFormatter3.string(from: date)
            }else if date < todayDate! {
                let dateFormatter3 = DateFormatter()
                dateFormatter3.dateStyle = .full
                dateFormatter3.locale = Locale(identifier: selectedLocale)
                dateFormatter3.doesRelativeDateFormatting = true
                cell?.labelDate.text = dateFormatter3.string(from: date)
            }else {
                let dateFormatter3 = DateFormatter()
                dateFormatter3.dateFormat = "hh::mm a"
                dateFormatter3.locale = Locale(identifier: selectedLocale)
                cell?.labelDate.text = dateFormatter3.string(from: date)
            }
        }
        if let isStarred = messageModel.isStarred , isStarred == 1{
            cell?.imgStar.image = #imageLiteral(resourceName: "fav")
        }else{
            cell?.imgStar.image = #imageLiteral(resourceName: "unfav")
        }
        if let readStatus = messageModel.readStatus , readStatus.lowercased() == "READ".lowercased(){
            cell?.backgroundColor = UIColor(red: 0.9565, green: 0.9565, blue: 0.9565, alpha: 1.0)
            cell?.labelDate.textColor = UIColor(red: 0.5490, green: 0.5490, blue:0.5490, alpha: 1.0)

            cell?.labelName.textColor = UIColor(red: 0.4196, green: 0.4235, blue:0.4431, alpha: 1.0)
            cell?.labelMessage.textColor = UIColor(red: 0.5490, green: 0.5490, blue:0.5490, alpha: 1.0)
        }else{
            cell?.backgroundColor = .white
             cell?.labelDate.textColor = UIColor(red: 0, green: 156.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
            cell?.labelName.textColor = UIColor.black
            cell?.labelMessage.textColor = UIColor(red: 0.1765, green: 0.1961, blue:0.2314, alpha: 1.0)
        }
        return cell!
    }
}


//MARK:- UITableViewDelegate

extension MessageController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let detailMessageController  = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.DetailMessageController) as! DetailMessageController
        detailMessageController.messageModel = filteredMessageArray[indexPath.row]
        self.navigationController?.pushViewController(detailMessageController, animated: true)
    }
}


//MARK:- UISearchControllerDelegate

extension MessageController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        var rect = messageTable.frame
        rect.origin.y = 0
        rect.size.height += self.tableY
        messageTable.frame = rect
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseIn],
                       animations: {
                        var rect = self.messageTable.frame
                        rect.origin.y = self.tableY
                        self.messageTable.frame = rect
        }, completion: nil)
    }
}

//MARK:- UITextFieldDelegate

extension MessageController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var rect = messageTable.frame
        if UIDevice.current.userInterfaceIdiom == .pad {
            rect.origin.y = 40
        }else{
            rect.origin.y = 20
        }
        rect.size.height = rect.size.height + navView.frame.size.height + navView.frame.origin.y
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseIn],
                       animations: {
                        self.cancelButton.isHidden = false
                        self.messageTable.frame = rect
                        self.cancelButtonTrailingConstrient.constant = 15
                        
        },completion: { (success) in
            self.cancelButton.isHidden = false
        })
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseIn],
                       animations: {
                        var rect = self.messageTable.frame
                        rect.origin.y = self.navView.frame.size.height + self.navView.frame.origin.y
                        rect.size.height = rect.size.height - self.navView.frame.size.height -  self.navView.frame.origin.y
                        self.messageTable.frame = rect
                        self.cancelButtonTrailingConstrient.constant = -self.cancelButton.frame.size.width
                        self.cancelButton.isHidden = true
        }, completion: { (success) in
            self.cancelButton.isHidden = true
        })
        return true
    }
    
}
