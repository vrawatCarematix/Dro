//
//  QuestionRichTextCell.swift
//  DRO
//
//  Created by Carematix on 08/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class QuestionRichTextCell: UITableViewCell {

    @IBOutlet weak var textViewRich: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        textViewRich.setCustomFont()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
