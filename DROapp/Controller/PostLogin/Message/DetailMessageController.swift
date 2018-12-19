//
//  DetailMessageController.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DetailMessageController: DROViewController {

    //MARK:- Outlet
    @IBOutlet var messageTable: UITableView!
    @IBOutlet var buttonFav: UIButton!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelUsername: UILabel!
    
    //MARK:- Variables

    var messageModel = MessageModel()

    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        labelDate.setCustomFont()
        labelUsername.setCustomFont()
        if let senderName = messageModel.senderName{
            labelUsername.text = senderName
        }
        if let createTime = messageModel.createTime{
            let endDate = Date(timeIntervalSince1970: TimeInterval(createTime / 1000))
            let dateFormatter = DateFormatter()
            if let selectedLanguageCode = kUserDefault.value(forKey: kselectedLanguage) as? String {
                dateFormatter.locale = Locale(identifier: selectedLanguageCode)
            }else{
                dateFormatter.locale = Locale(identifier: "EN")
            }
            dateFormatter.dateFormat = "EEEE, MMMM dd'Sufix', yyyy 'at' hh:mm a"
            let calendar = Calendar.current
            let dayOfMonth = calendar.component(.day, from: endDate)
            let dateString = dateFormatter.string(from: endDate).replacingOccurrences(of: "Sufix", with: dayOfMonth.ordinal)
            labelDate.text = dateString
        }
        if let isStarred = messageModel.isStarred , isStarred == 1{
           buttonFav.isSelected = true
        }else{
            buttonFav.isSelected = false
        }
        
        self.messageTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        // Do any additional setup after loading the view.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.messageTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if newSize.height > (self.messageTable.frame.size.height){
                        self.messageTable.isScrollEnabled = true
                    }else{
                        self.messageTable.isScrollEnabled = false
                    }
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Button Action

    @IBAction func back(_ sender: UIButton) {
        var update = false
        if let readStatus = messageModel.readStatus ,  readStatus.lowercased() != "READ".lowercased(){
            messageModel.readStatus = "READ"
            update = true
        }
        if let isStarred = messageModel.isStarred , buttonFav.isSelected  && isStarred != 1{
            messageModel.isStarred  = 1
            update = true
        }else if let isStarred = messageModel.isStarred , !buttonFav.isSelected  && isStarred != 0{
            messageModel.isStarred  = 0
            update = true
        }
        
        if update{
            updateOnServer()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func changeFav(_ sender: UIButton) {
        buttonFav.isSelected = !buttonFav.isSelected
    }
    
    
    //MARK:- Update Message On Server
    func updateOnServer() {
        //Check Network Reachability
        if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
            //Network Available
            CustomActivityIndicator.startAnimating( message: kUpdating.localisedString() +  "...")
            updateMessageOnServer(messageModel) { (success, response, message ,responseHeader) in
                DispatchQueue.main.async {
                    CustomActivityIndicator.stopAnimating()
                   // debugPrint("UpdateMessage -->" + response.description)
                    CustomActivityIndicator.stopAnimating()
                    if success {
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showErrorAlert(titleString: kAlert.localisedString(), message: message)
                    }
                }
            }
        }else{
            messageModel.isUploaded = 0
            let _ = DatabaseHandler.insertIntoMessageTable(messageArray: [messageModel])
        }
    }
    
}

//MARK:- UITableViewDataSource

extension DetailMessageController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DetailMessageCell) as? DetailMessageCell
        cell?.selectionStyle = .none
        if let mesageTitle = messageModel.messageTile , mesageTitle != "" {
            let lastString =  NSMutableAttributedString(string: mesageTitle, attributes: [NSAttributedString.Key.font: UIFont(name: kSFSemibold, size: CGFloat(self.view.getCustomFontSize(size: (Int((cell?.labelMessage.font.pointSize)!) + 1 )))) as Any])
            lastString.append(NSAttributedString(string: "\n \n" + (messageModel.textMessage?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespacesAndNewlines) ?? "" )))
            cell?.labelMessage.attributedText = lastString
            
        }else{
            cell?.labelMessage.text = messageModel.textMessage?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespacesAndNewlines)

        }
        
        return cell!
    }
}

//MARK:- UITableViewDelegate

extension DetailMessageController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
}
