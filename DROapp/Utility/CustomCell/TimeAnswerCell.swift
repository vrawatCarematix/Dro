//
//  TimeAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 20/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TimeAnswerCell: UITableViewCell {

    @IBOutlet var upperView: UIView!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var imgArrow: UIImageView!
    @IBOutlet var labelTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTime.setCustomFont()
        labelTime.text = "Select time"
        timePicker.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func showTimePicker(_ sender: UIButton) {
        timePicker.isHidden = !timePicker.isHidden
        if timePicker.isHidden {
            imgArrow.image = #imageLiteral(resourceName: "downArrow")
            upperView.backgroundColor = .white
            
        }else{
            imgArrow.image = #imageLiteral(resourceName: "upArrowGray")
            upperView.backgroundColor = .lightGray
        }
        
    }
    @IBAction func timeValueChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        labelTime.text = dateFormatter.string(from: timePicker.date)
    }
    
}
