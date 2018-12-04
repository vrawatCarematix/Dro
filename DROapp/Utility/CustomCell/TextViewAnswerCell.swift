//
//  TextViewAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 20/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TextViewAnswerCell: UITableViewCell {

    @IBOutlet var richTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        richTextView.setCustomFont()
        richTextView.text = "Enter text"
        richTextView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TextViewAnswerCell : UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Enter text" {
            richTextView.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        var characterSet = NSMutableCharacterSet.whitespacesAndNewlines
        characterSet.formUnion(.symbols)
        characterSet.formUnion(.illegalCharacters)
        characterSet.formUnion(.punctuationCharacters)

        if textView.text.trimmingCharacters(in: characterSet) == "" {
            richTextView.text = "Enter text"
        }
    }
}
