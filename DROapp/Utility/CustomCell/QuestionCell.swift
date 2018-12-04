//
//  QuestionCell.swift
//  DROapp
//
//  Created by Carematix on 09/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet var labelQuestion: UILabel!
    @IBOutlet var labelQuestionNumber: UILabel!
    var helpText = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelQuestionNumber.setCustomFont()
        labelQuestion.setCustomFont()
        // Initialization code
    }

    func configureCell( questionNumber : String , question :String , hint : String)  {
        labelQuestion.text = question
        labelQuestionNumber.text = questionNumber
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func showHint(_ sender: UIButton) {
        let view = CustomSuccessAlert.instanceFromNib(message: helpText)
        UIApplication.shared.keyWindow?.addSubview(view)
        
    }
    
}
