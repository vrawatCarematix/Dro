//
//  DeclineCell.swift
//  DROapp
//
//  Created by Carematix on 31/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DeclineCell: UITableViewCell {

    @IBOutlet var labelDroName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDroName.setCustomFont()
        labelDroName.numberOfLines = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
