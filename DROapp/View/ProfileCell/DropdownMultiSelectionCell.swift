//
//  DropdownMultiSelectionCell.swift
//  DROapp
//
//  Created by Carematix on 01/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
class DropdownMultiSelectionCell: UITableViewCell {
    @IBOutlet var labelData: UILabel!
    
    @IBOutlet var imgSelection: UIImageView!
    override func awakeFromNib() {
        labelData.setCustomFont()
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
