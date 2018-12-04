//
//  ScheduleHeaderCell.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ScheduleHeaderCell: UITableViewCell {

    @IBOutlet var labelDro: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDro.setCustomFont()
       // labelDro.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
