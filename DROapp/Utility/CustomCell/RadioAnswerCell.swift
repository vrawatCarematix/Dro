//
//  RadioAnswerCell.swift
//  DRO
//
//  Created by Carematix on 07/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
@objc protocol RadioAnswerCellDelegate {
    @objc func rowSelected( answer: AnswersModel , cell: RadioAnswerCell)
}
class RadioAnswerCell: UITableViewCell {
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    weak var delegate: RadioAnswerCellDelegate?
    var answer = AnswersModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        labelQuestion.setCustomFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            if let delegate = self.delegate {
                delegate.rowSelected(answer: answer, cell: self)
            }
        }
        // Configure the view for the selected state
    }

}
