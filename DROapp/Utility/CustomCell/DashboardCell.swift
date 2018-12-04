//
//  DashboardCell.swift
//  DRO
//
//  Created by Carematix on 02/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    
    @IBOutlet weak var imageViewTask: UIImageView!
    
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var labelTask: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTask.setCustomFont()
        statusButton.setCustomFont()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

}
