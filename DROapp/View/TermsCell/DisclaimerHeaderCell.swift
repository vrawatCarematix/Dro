//
//  DisclaimerHeaderCell.swift
//  DROapp
//
//  Created by Carematix on 13/11/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DisclaimerHeaderCell: UITableViewCell {

    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelLastUpdated: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDate.setCustomFont()
        labelLastUpdated.setCustomFont()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
