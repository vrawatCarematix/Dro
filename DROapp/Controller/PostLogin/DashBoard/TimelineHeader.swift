//
//  TimelineHeader.swift
//  DROapp
//
//  Created by Carematix on 14/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TimelineHeader: UITableViewCell {

    @IBOutlet var buttonClose: UIButton!
    @IBOutlet var labelStatistics: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelStatistics.setCustomFont()

        // Initialization code
    }

    @IBAction func collapseCell(_ sender: UIButton) {
        let dict = [kOpen : Collapse.close , kCell : DashboardCellType.Timeline] as [String : Any]
        
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }

}
