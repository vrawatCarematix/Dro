//
//  TimelineHeaderCell.swift
//  DROapp
//
//  Created by Carematix on 09/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TimelineHeaderCell: UITableViewCell {

    @IBOutlet var imgLower: UIImageView!
    @IBOutlet var imgUpper: UIImageView!
    @IBOutlet var timelineDateNumber: UILabel!
    @IBOutlet var timelineDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        timelineDate.setCustomFont()
        timelineDateNumber.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
