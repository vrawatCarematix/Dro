//
//  DropdownSingleSelectionCell.swift
//  DROapp
//
//  Created by Carematix on 01/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import DropDown
class DropdownSingleSelectionCell: UITableViewCell {
    @IBOutlet var labelData: UILabel!
   
    @IBOutlet var imgSelection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelData.setCustomFont()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
