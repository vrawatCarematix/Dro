//
//  StudyTableReadLessCell.swift
//  DROapp
//
//  Created by Carematix on 12/11/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class StudyTableReadLessCell: UITableViewCell {

    @IBOutlet var readMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        readMoreButton.setCustomFont()
        // Initialization code
    }

}
