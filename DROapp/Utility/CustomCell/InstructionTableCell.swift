//
//  InstructionTableCell.swift
//  DRO
//
//  Created by Carematix on 09/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class InstructionTableCell: UITableViewCell {
    @IBOutlet weak var instructionImage: UIImageView!
    
    @IBOutlet weak var instructionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        instructionLabel.setCustomFontSize(size: 11)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
