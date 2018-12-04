//
//  TextAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 20/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TextAnswerCell: UITableViewCell {

    @IBOutlet var answerTextfield: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        answerTextfield.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
