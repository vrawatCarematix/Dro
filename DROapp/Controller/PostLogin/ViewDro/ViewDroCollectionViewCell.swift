//
//  ViewDroCollectionViewCell.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ViewDroCollectionViewCell: UICollectionViewCell {
    @IBOutlet var labelNumber: UILabel!
    
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    override func awakeFromNib() {
        labelTitle.setCustomFont()
        labelNumber.setCustomFont()
        
    }
    
}
