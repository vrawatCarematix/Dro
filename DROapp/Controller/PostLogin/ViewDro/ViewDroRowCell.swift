//
//  ViewDroRowCell.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ViewDroRowCell: UITableViewCell {

    @IBOutlet var heightConstant: NSLayoutConstraint!
    @IBOutlet var droListTable: UITableView!
    var maximumHeight = CGFloat(0)

    override func awakeFromNib() {
        super.awakeFromNib()
        droListTable.dataSource = self
        droListTable.delegate = self
        self.droListTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
       
        // Initialization code
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.droListTable && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    var rect = self.droListTable.frame
                    rect.origin.y = 0
                    heightConstant.constant = newSize.height
                    if maximumHeight > 10 && newSize.height > maximumHeight {
                        heightConstant.constant = maximumHeight
                       // rect.size.height = maximumHeight
                    }else{
                        heightConstant.constant = newSize.height
                        //rect.size.height = newSize.height
                    }
                    
                  //  self.droListTable.frame = rect
                    self.droListTable.layer.cornerRadius = 5
                    self.droListTable.clipsToBounds = true
                    
                }
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ViewDroRowCell : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.ViewDroListCell) as? ViewDroListCell
    
        return cell!
    }
}

extension ViewDroRowCell : UITableViewDelegate{
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    
}
