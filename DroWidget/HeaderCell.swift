//
//  HeaderCell.swift
//  DroWidget
//
//  Created by Carematix on 05/12/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet var headerBackgroundImage: UIImageView!
    @IBOutlet var headerTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
