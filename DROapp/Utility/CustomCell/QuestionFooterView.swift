//
//  QuestionFooterView.swift
//  DRO
//
//  Created by Carematix on 07/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class QuestionFooterView: UITableViewCell {
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        nextButton.setCustomFont()
        previousButton.setCustomFont()

        // Initialization code
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
