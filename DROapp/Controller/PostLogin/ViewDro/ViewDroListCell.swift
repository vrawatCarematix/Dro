//
//  ViewDroListCell.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ViewDroListCell: UITableViewCell {

    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var labelDroStatus: UILabel!
    @IBOutlet var labelDroType: UILabel!
    @IBOutlet var labelDueBy: UILabel!
    @IBOutlet var labelDroName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDueBy.setCustomFont()
        labelDroName.setCustomFont()
        labelDroType.setCustomFont()
        labelDroStatus.setCustomFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
