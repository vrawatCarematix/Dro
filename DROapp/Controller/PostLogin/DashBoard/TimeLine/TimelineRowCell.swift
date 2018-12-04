//
//  TimelineRowCell.swift
//  DROapp
//
//  Created by Carematix on 09/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TimelineRowCell: UITableViewCell {

    @IBOutlet var imgTimeline: UIImageView!
    @IBOutlet var imgDetail: UIImageView!
    @IBOutlet var labelDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDetail.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
