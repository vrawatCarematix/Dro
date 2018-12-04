//
//  DroDetailCell.swift
//  DROapp
//
//  Created by Carematix on 31/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DroDetailCell: UITableViewCell {

    @IBOutlet var labelQuestionnaireName: UILabel!
    
    @IBOutlet var labelQuestionnaireType: UILabel!
    
    @IBOutlet var labelQuestionaireDescription: UILabel!
    
    @IBOutlet var labelDueBy: UILabel!
    
    @IBOutlet var labelDueDate: UILabel!
    
    @IBOutlet var imgDue: UIImageView!
    
    @IBOutlet var labelEstimated: UILabel!
    
    @IBOutlet var labelEstimatedTime: UILabel!
    
    @IBOutlet var imgEstimated: UIImageView!
    
    @IBOutlet var labelInstruction: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelQuestionnaireName.setCustomFont()
        labelQuestionnaireType.setCustomFont()
        labelQuestionaireDescription.setCustomFont()
        labelDueBy.setCustomFont()
        labelDueDate.setCustomFont()
        labelEstimatedTime.setCustomFont()
        labelEstimated.setCustomFont()
        labelInstruction.setCustomFont()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
