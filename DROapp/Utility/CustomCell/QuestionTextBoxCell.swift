//
//  QuestionTextBoxCellTableViewCell.swift
//  DRO
//
//  Created by Carematix on 07/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class QuestionTextBoxCell: UITableViewCell {
    @IBOutlet weak var answerTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        answerTextField.setCustomFont()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
