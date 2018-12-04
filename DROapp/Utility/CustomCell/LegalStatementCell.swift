//
//  LegalStatementCell.swift
//  DROapp
//
//  Created by Carematix on 29/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class LegalStatementCell: UITableViewCell {

    @IBOutlet var labelMessage: UILabel!
    @IBOutlet var labelBullet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelMessage.setCustomFont()
        labelBullet.setCustomFont()
        labelBullet.text = "\u{2022}"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
