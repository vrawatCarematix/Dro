//
//  EditProfileTextViewCell.swift
//  DROapp
//
//  Created by Carematix on 08/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
@objc protocol EditProfileTextViewCellDelegate {
    @objc  func textViewDidChange(_ textView: UITextView , height: CGFloat )
}
class EditProfileTextViewCell: UITableViewCell {
    weak var delegate: EditProfileTextViewCellDelegate?

    @IBOutlet var textViewHeight: NSLayoutConstraint!
    @IBOutlet var textViewData: UITextView!
    @IBOutlet var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.setCustomFont()
        textViewData.setCustomFont()
        textViewData.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension EditProfileTextViewCell : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
       // textViewData.sizeToFit()

        var rect = self.textViewData.frame
        
//        if self.textViewData.contentSize.height < 60 {
        rect.size.height = self.textViewData.contentSize.height
//
//        }else{
//            rect.size.height = 60
//
//        }
       // self.textViewData.frame = rect
        if self.textViewData.contentSize.height > self.textViewHeight.constant {
            self.textViewHeight.constant = self.textViewData.contentSize.height

            if let delegat = delegate {
                delegat.textViewDidChange(textView, height: self.textViewData.contentSize.height)
            }
        }
        self.textViewHeight.constant = self.textViewData.contentSize.height

    }
}
