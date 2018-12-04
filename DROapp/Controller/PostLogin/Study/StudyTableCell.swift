//
//  StudyTableCell.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class StudyTableCell: UITableViewCell {

    @IBOutlet var labelHeader: UILabel!
    @IBOutlet var readMoreButton: UIButton!
    @IBOutlet var labelDetail: UILabel!
    @IBOutlet var labelBottomConstrient: NSLayoutConstraint!
    @IBOutlet var buttonTopConstrient: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        labelHeader.setCustomFont()
        labelDetail.setCustomFont()
        readMoreButton.setCustomFont()
        // Initialization code
    }

   
}
