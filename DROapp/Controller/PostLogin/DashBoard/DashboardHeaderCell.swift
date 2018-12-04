//
//  DashboardHeaderCell.swift
//  DROapp
//
//  Created by Carematix on 06/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import FoldingCell
class DashboardHeaderCell: UITableViewCell  {

    @IBOutlet var labelLastLogin: UILabel!
    @IBOutlet var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelLastLogin.setCustomFont()
        userName.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
