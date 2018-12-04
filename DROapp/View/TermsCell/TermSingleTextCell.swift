//
//  TermTextCell.swift
//  DROapp
//
//  Created by Carematix on 07/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TermSingleTextCell: UITableViewCell {
    @IBOutlet var labelDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDetail.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
