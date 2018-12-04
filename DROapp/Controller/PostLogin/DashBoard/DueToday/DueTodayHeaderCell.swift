//
//  DueTodayHeaderCell.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DueTodayHeaderCell: UITableViewCell {

    @IBOutlet var buttonCollapase: UIButton!
    @IBOutlet var labelDueToday: UILabel!
    @IBOutlet var buttonClose: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDueToday.setCustomFont()
        // Initialization code
    }


    @IBAction func collapseCell(_ sender: UIButton) {
        let dict = [kOpen : Collapse.close , kCell : DashboardCellType.DueToday] as [String : Any]
        
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }
    
}
