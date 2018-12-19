//
//  StudyController.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class StudyController: DROViewController {
    
    //MARK:- Outlets
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var studyTable: UITableView!
    
    //MARK:- Variables
    var legalStatmentArray = [ConfigDatabaseModel]()
    var openSection = [Int]()
    
    //MARK:- ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.setCustomFont()
        legalStatmentArray = DatabaseHandler.getAllConfig(kSTUDY_INFO)
        legalStatmentArray = legalStatmentArray.filter({ $0.fieldType == kDIV_HEADER_BODY })
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)
        
        let textCellNib = UINib(nibName: ReusableIdentifier.TermTextCell, bundle: nil)
        studyTable.register(textCellNib, forCellReuseIdentifier: ReusableIdentifier.TermTextCell)
        
        let videoCellNib = UINib(nibName: ReusableIdentifier.TermVideoCell, bundle: nil)
        studyTable.register(videoCellNib, forCellReuseIdentifier: ReusableIdentifier.TermVideoCell)
        
        let audioCellNib = UINib(nibName: ReusableIdentifier.TermAudioCell, bundle: nil)
        studyTable.register(audioCellNib, forCellReuseIdentifier: ReusableIdentifier.TermAudioCell)
        
        let imageCellNib = UINib(nibName: ReusableIdentifier.TermImageCell, bundle: nil)
        studyTable.register(imageCellNib, forCellReuseIdentifier: ReusableIdentifier.TermImageCell)
        
        let termCellNib = UINib(nibName: ReusableIdentifier.TermWebCell, bundle: nil)
        studyTable.register(termCellNib, forCellReuseIdentifier: ReusableIdentifier.TermWebCell)
        
        setText()
    }
    
    //MARK:- Changes Text on language Changes
    
    @objc func setText()  {
        studyTable.reloadData()
        labelTitle.text = kStudy_Information.localisedString().capitalized
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
    }
    
    //MARK:- Button Action
    @objc func readMoreDetail(_ sender : UIButton){
        if let index = openSection.firstIndex(of: sender.tag) {
            openSection.remove(at: index)
        }else{
            openSection.append(sender.tag)
        }
        studyTable.reloadData()
    }
    
}

//MARK:- UITableViewDataSource

extension StudyController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openSection.contains(section){
          //  return legalStatmentArray.count + 1
            return 2
        }else{
            return 0

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.StudyTableReadLessCell) as? StudyTableReadLessCell
            cell?.readMoreButton.setTitle(kRead_Less.localisedString().capitalized, for: .normal)
            cell?.readMoreButton.tag = indexPath.section
            cell?.readMoreButton.addTarget(self, action: #selector(readMoreDetail(_:)), for: .touchUpInside)
            return cell!
        }
        let statement = legalStatmentArray[indexPath.section]
        if let urlType = statement.urlType {
            if urlType.lowercased() == kImage.lowercased() {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermImageCell, for: indexPath)  as? TermImageCell
                cell?.selectionStyle = .none
                return cell!
            }else if urlType.lowercased() == kAudio.lowercased() {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermAudioCell, for: indexPath)  as? TermAudioCell
                cell?.selectionStyle = .none
                return cell!
            }else if let url = statement.url ,urlType.lowercased() == kVideo.lowercased() && url.lowercased().contains("www.youtube.com") {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermWebCell, for: indexPath)  as? TermWebCell
                cell?.labelTitle.text = statement.header
                cell?.labelDetail.text = statement.descriptions
                cell?.webUrl = url
                cell?.selectionStyle = .none
                return cell!
            }else if let _ = statement.url , urlType.lowercased() == kVideo.lowercased() {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermVideoCell, for: indexPath)  as? TermVideoCell
                cell?.selectionStyle = .none
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermTextCell, for: indexPath)  as? TermTextCell
                cell?.labelTitle.text = statement.header
                cell?.labelDetail.text = statement.descriptions
                cell?.selectionStyle = .none
                return cell!
            }
        }else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermTextCell, for: indexPath)  as? TermTextCell
            cell?.labelTitle.text = statement.header
            cell?.labelDetail.text = statement.descriptions
            cell?.selectionStyle = .none
            return cell!
        }
    }
}

//MARK:- UITableViewDelegate

extension StudyController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return legalStatmentArray.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.StudyTableCell) as? StudyTableCell
        //cell?.labelDetail.numberOfLines = 0
        cell?.labelHeader.text = legalStatmentArray[section].header
        cell?.labelDetail.text = legalStatmentArray[section].descriptions
        if let  lines = cell?.labelDetail.calculateMaxLines() , lines > 4{
            cell?.readMoreButton.isUserInteractionEnabled = true
            cell?.readMoreButton.setTitle(kRead_More.localisedString().capitalized, for: .normal)
            if let topConstraint = cell?.buttonTopConstrient , let bottomConstraint = cell?.labelBottomConstrient{
                NSLayoutConstraint.deactivate([bottomConstraint])
                NSLayoutConstraint.activate([topConstraint])
            }
        }else{
            cell?.readMoreButton.setTitle("", for: .normal)
            cell?.readMoreButton.isUserInteractionEnabled = false
            if let topConstraint = cell?.buttonTopConstrient , let bottomConstraint = cell?.labelBottomConstrient{
                NSLayoutConstraint.deactivate([topConstraint])
                NSLayoutConstraint.activate([bottomConstraint])
            }
        }
        cell?.readMoreButton.tag = section
        cell?.readMoreButton.addTarget(self, action: #selector(readMoreDetail(_:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if openSection.contains(section){
            return 0
        }else{
            return UITableView.automaticDimension
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if openSection.contains(section){
            return 0
        }else{
            return 20
        }
    }
}
