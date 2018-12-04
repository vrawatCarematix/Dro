//
//  DetailTermViewController.swift
//  DROapp
//
//  Created by Carematix on 07/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DetailTermViewController: UIViewController {

    @IBOutlet var detailTable: UITableView!
    @IBOutlet var labelTitle: UILabel!
    var titleString = String()
    var legalStatmentArray = [ConfigDatabaseModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if titleString == kDisclaimer.localisedString() {
            legalStatmentArray = DatabaseHandler.getAllConfig(pDisclaimer)
        }
        labelTitle.setCustomFont()
        labelTitle.text = titleString
        let textCellNib = UINib(nibName: ReusableIdentifier.TermTextCell, bundle: nil)
        detailTable.register(textCellNib, forCellReuseIdentifier: ReusableIdentifier.TermTextCell)
        
        let videoCellNib = UINib(nibName: ReusableIdentifier.TermVideoCell, bundle: nil)
        detailTable.register(videoCellNib, forCellReuseIdentifier: ReusableIdentifier.TermVideoCell)
        
        let audioCellNib = UINib(nibName: ReusableIdentifier.TermAudioCell, bundle: nil)
        detailTable.register(audioCellNib, forCellReuseIdentifier: ReusableIdentifier.TermAudioCell)
        
        let imageCellNib = UINib(nibName: ReusableIdentifier.TermImageCell, bundle: nil)
        detailTable.register(imageCellNib, forCellReuseIdentifier: ReusableIdentifier.TermImageCell)
        
        let termCellNib = UINib(nibName: ReusableIdentifier.TermWebCell, bundle: nil)
        detailTable.register(termCellNib, forCellReuseIdentifier: ReusableIdentifier.TermWebCell)
        self.detailTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        // Do any additional setup after loading the view.
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.detailTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if newSize.height > (self.detailTable.frame.size.height ) {
                        self.detailTable.isScrollEnabled = true
                    }else{
                        self.detailTable.isScrollEnabled = false
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension DetailTermViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legalStatmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let statement = legalStatmentArray[indexPath.row]
        
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
           }else if let url = statement.url , urlType.lowercased() == kVideo.lowercased() {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermVideoCell, for: indexPath)  as? TermVideoCell
            
            cell?.selectionStyle = .none
            return cell!
            
           
           }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermTextCell, for: indexPath)  as? TermTextCell
            cell?.labelTitle.text = ""//statement.header
            cell?.labelDetail.text = statement.descriptions

            
            cell?.selectionStyle = .none
            return cell!
            }
        }else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.TermTextCell, for: indexPath)  as? TermTextCell
            cell?.labelTitle.text = ""//statement.header
            cell?.labelDetail.text = statement.descriptions

            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    
}

extension DetailTermViewController : UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.DisclaimerHeaderCell)  as? DisclaimerHeaderCell
        if legalStatmentArray.count > 0 {
            cell?.labelDate.text = legalStatmentArray[0].lastVisitedDate
        }else{
            cell?.labelDate.text = ""
            
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if titleString == kDisclaimer.localisedString() {
        return UITableView.automaticDimension
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}


