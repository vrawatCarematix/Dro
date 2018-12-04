//
//  DetailMessageCell.swift
//  DROapp
//
//  Created by Carematix on 22/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DetailMessageCell: UITableViewCell {
    @IBOutlet var labelMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelMessage.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
