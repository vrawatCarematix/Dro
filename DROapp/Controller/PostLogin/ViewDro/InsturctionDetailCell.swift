//
//  InsturctionDetail.swift
//  DROapp
//
//  Created by Carematix on 31/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class InsturctionDetailCell: UITableViewCell {
    @IBOutlet var imgInstruction: UIImageView!
    @IBOutlet var labelInstruction: ExpandableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelInstruction.setCustomFont()
        labelInstruction.collapsed = true
        labelInstruction.text = nil
        // Initialization code
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelInstruction.collapsed = true
        labelInstruction.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
