//
//  PTableViewCell.swift
//  DROapp
//
//  Created by Carematix on 07/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelData: UILabel!

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

}
