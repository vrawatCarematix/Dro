//
//  RowCell.swift
//  DroWidget
//
//  Created by Carematix on 05/12/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class RowCell: UITableViewCell {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var rowBackgroundImage: UIImageView!
    @IBOutlet var rowTitle: UILabel!
    
    @IBOutlet var bottomConstrientToProgressView: NSLayoutConstraint!
    
    @IBOutlet var bottomConstrientToSuperView: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.layer.cornerRadius = progressView.frame.size.height
        progressView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
