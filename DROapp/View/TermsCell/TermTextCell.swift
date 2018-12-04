//
//  TermTextCell.swift
//  DROapp
//
//  Created by Carematix on 07/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TermTextCell: UITableViewCell {
    @IBOutlet var labelDetail: UILabel!
    
    @IBOutlet var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.setCustomFont()
        labelDetail.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
