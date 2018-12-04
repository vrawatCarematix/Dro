//
//  UpcomingHeaderCell.swift
//  DROapp
//
//  Created by Carematix on 09/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class UpcomingHeaderCell: UITableViewCell {

    @IBOutlet var buttonCollapse: UIButton!
    @IBOutlet var labelUpcoming: UILabel!
    
    @IBOutlet var closeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelUpcoming.setCustomFont()
        // Initialization code
    }

    @IBAction func collapseCell(_ sender: UIButton) {
        let dict = [kOpen : Collapse.close , kCell : DashboardCellType.Upcoming] as [String : Any]
        
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: kDashboardCollapse), object: dict)
    }
    

}
