//
//  MessageTableCell.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {

    @IBOutlet var labelMessage: UILabel!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var imgStar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDate.setCustomFont()
        labelName.setCustomFont()
        labelMessage.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
