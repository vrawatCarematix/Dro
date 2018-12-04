//
//  EditProfileTextCell.swift
//  DROapp
//
//  Created by Carematix on 08/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class EditProfileTextCell: UITableViewCell {

    @IBOutlet var textfieldData: UITextField!
    @IBOutlet var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.setCustomFont()
        textfieldData.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
