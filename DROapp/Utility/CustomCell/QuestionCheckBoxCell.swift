//
//  QuestionCheckBoxCell.swift
//  DRO
//
//  Created by Carematix on 08/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

@objc protocol QuestionCheckBoxCellDelegate {
    @objc func checkBoxSelected( answer: AnswersModel , cell: QuestionCheckBoxCell)
}

class QuestionCheckBoxCell: UITableViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var labelQuestion: UILabel!
    
    @IBOutlet weak var buttonCheck: UIButton!
    
    weak var delegate: QuestionCheckBoxCellDelegate?
    var answer = AnswersModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        labelQuestion.setCustomFont()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            if let delegate = self.delegate {
                delegate.checkBoxSelected(answer: answer, cell: self)
            }
        }
        // Configure the view for the selected state
    }
    

}
