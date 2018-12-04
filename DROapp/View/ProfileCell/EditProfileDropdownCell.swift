//
//  EditProfileDropdownCell.swift
//  DROapp
//
//  Created by Carematix on 08/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//
import DropDown

import UIKit
@objc protocol EditProfileDropdownCellDelegate {
    @objc func clickedOnButton(_ sender: UIButton )
}
class EditProfileDropdownCell: UITableViewCell {
    let dropDown = DropDown()
    weak var delegate: EditProfileDropdownCellDelegate?

    @IBOutlet var imgArrow: UIImageView!
    var selectedIndex = -1
    @IBOutlet var labelData: UILabel!
    @IBOutlet var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.setCustomFont()
        labelData.setCustomFont()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func showDropDown(_ sender: UIButton) {
        if let delegat = delegate {
            delegat.clickedOnButton(sender)
        }        
    }
}

