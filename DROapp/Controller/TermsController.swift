//
//  TermsController.swift
//  DROapp
//
//  Created by Carematix on 07/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TermsController: UIViewController {

    @IBOutlet var tableTerms: UITableView!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelLastUpdated: UILabel!
    @IBOutlet var labelTitle: UILabel!
    var termsArray = [String]()
    var termsType = String()
    var legalStatmentArray = [ConfigDatabaseModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableTerms.tableFooterView = UIView()
        if termsType == kTermsCondition{
            labelTitle.text = kTerms_Conditions.localisedString()
            termsArray = ["Acceptance of Terms" , "Description of Services" , "Privacy & Protection of Personal Information"]
            legalStatmentArray = DatabaseHandler.getAllConfig(kTerm_Condition)
            if legalStatmentArray.count > 0 {
                labelDate.text = legalStatmentArray[0].lastVisitedDate
            }else{
                labelDate.text = ""

            }
        }else{
            labelTitle.text = kPrivacy_Policy.localisedString() 
            termsArray = ["Personal Data We Collect" , "How We Use Personal Data" , "Reasons We Share Personal Data"]
            legalStatmentArray = DatabaseHandler.getAllConfig(kPrivacyPolicy)
            if legalStatmentArray.count > 0 {
                labelDate.text = legalStatmentArray[0].lastVisitedDate
            }else{
                labelDate.text = ""
                
            }
        }
        self.initialiseData()
        // Do any additional setup after loading the view.
    }

    func initialiseData() {
        labelDate.setCustomFont()
        labelTitle.setCustomFont()
        labelLastUpdated.setCustomFont()
        labelLastUpdated.text = kLast_Updated.localisedString() + ": "
    }
   
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension TermsController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return termsArray.count
        return legalStatmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermsCell, for: indexPath)  as? TermsCell
        //cell?.labelTitle.text = termsArray[indexPath.row]
        cell?.labelTitle.text = legalStatmentArray[indexPath.row].header

        cell?.selectionStyle = .none
        return cell!
    }
    
    
}

extension TermsController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController  = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.DetailTermViewController) as! DetailTermViewController
        detailController.legalStatmentArray =  [legalStatmentArray[indexPath.row]]
        detailController.titleString = legalStatmentArray[indexPath.row].header ?? ""
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}

