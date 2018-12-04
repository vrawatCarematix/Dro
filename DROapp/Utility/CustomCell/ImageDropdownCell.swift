//
//  ImageDropdownCell.swift
//  DROapp
//
//  Created by Carematix on 06/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
@objc protocol ImageDropdownCellDelegate {
    @objc func imageSelected( answer: AnswersModel , cell: ImageDropdownCell)
}
class ImageDropdownCell: UITableViewCell {
    @IBOutlet var imgageOption: UIImageView!
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
    @IBOutlet var backGroundImage: UIImageView!
    @IBOutlet var optionImageHeightConstant: NSLayoutConstraint!
    
    var imageUrl = String()
    weak var delegate: ImageDropdownCellDelegate?
    var answer = AnswersModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            if let delegate = self.delegate {
                delegate.imageSelected(answer: answer, cell: self)
            }
        }
        // Configure the view for the selected state
    }

}
