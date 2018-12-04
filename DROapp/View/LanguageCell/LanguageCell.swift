//
//  LanguageCell.swift
//  DROapp
//
//  Created by Carematix on 06/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet var labelLanguage: UILabel!
    @IBOutlet var imgSelected: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelLanguage.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
