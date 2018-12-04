//
//  RatingAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 09/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class RatingAnswerCell: UITableViewCell {

    @IBOutlet var ratingViewHeightConstant: NSLayoutConstraint!
    @IBOutlet var label5: UILabel!
    @IBOutlet var label4: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label1: UILabel!
    @IBOutlet var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.starSize = Double((UIScreen.main.bounds.width - 50) / 5)
        
        ratingViewHeightConstant.constant = CGFloat(Double((UIScreen.main.bounds.width - 50) / 5) - 5)
        //        ratingView.filledBorderWidth = Double(ratingView.getCustomFontSize(size: 2))
//        ratingView.emptyBorderWidth = Double(ratingView.getCustomFontSize(size: 2))
        
    label1.setCustomFont()
        label2.setCustomFont()
        label3.setCustomFont()
        label4.setCustomFont()
        label5.setCustomFont()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
