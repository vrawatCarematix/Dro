//
//  QuestionSliderCell.swift
//  DRO
//
//  Created by Carematix on 08/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class QuestionSliderCell: UITableViewCell {
    @IBOutlet weak var questionSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        //labelQuestion.setCustomFont()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
