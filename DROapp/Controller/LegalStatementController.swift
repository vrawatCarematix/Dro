//
//  LegalStatementController.swift
//  DROapp
//
//  Created by Carematix on 29/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class LegalStatementController: DROViewController {

    //MARK: - Outlets

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var legalStatementTable: UITableView!
    @IBOutlet var labelSubHeading: UILabel!
    @IBOutlet var labelHeading: UILabel!
    
    //MARK: - Variables

    var legalStatmentData = [ConfigDatabaseModel]()
    var legalStatmentArray = [ConfigDatabaseModel]()

    //MARK: - View life cycle

    override func viewDidLoad() {
        labelTitle.setCustomFont()
        labelHeading.setCustomFont()
        labelSubHeading.setCustomFont()
        
        // Fatching Legal Statement From Database
        legalStatmentData = DatabaseHandler.getAllConfig(kLegalStatement)
        
        let header = legalStatmentData.filter({ $0.fieldType == kDivHeader })
        if header.count > 0  {
            labelHeading.text = header[0].header
        }
        let subHeader = legalStatmentData.filter({ $0.fieldType == kDivSubheader })
        if subHeader.count > 0 {
            labelSubHeading.text = subHeader[0].header
        }
        legalStatmentArray = legalStatmentData.filter({ $0.fieldType == kDivBody })
        self.legalStatementTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        labelTitle.text = kLegal_Statement.localisedString()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.legalStatementTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if newSize.height > (self.legalStatementTable.frame.size.height){
                        self.legalStatementTable.isScrollEnabled = true
                    }else{
                        self.legalStatementTable.isScrollEnabled = false
                    }
                }
            }
        }
    }
    
    //MARK: - Button Action

    @IBAction func closeController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UITableViewDataSource

extension LegalStatementController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legalStatmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.LegalStatementCell, for: indexPath)  as? LegalStatementCell
        cell?.labelMessage.text = legalStatmentArray[indexPath.row].descriptions
        cell?.selectionStyle = .none
        return cell!
    }

}

//MARK: - UITableViewDataSource
extension LegalStatementController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}


