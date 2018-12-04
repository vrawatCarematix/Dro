//
//  SliderAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 20/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
class SliderAnswerCell: UITableViewCell {

    @IBOutlet var seekSlider: TTRangeSlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        seekSlider.maxLabelFont = UIFont.init(name: kSFRegular, size: CGFloat(self.getCustomFontSize(size: 14)))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
