//
//  DateAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 20/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DateAnswerCell: UITableViewCell {

    @IBOutlet var upparView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var openDatePicker: UIButton!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var imgArrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDate.setCustomFont()
        labelDate.text = "Select Date"
        datePicker.isHidden = true
      
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func showDatePicker(_ sender: UIButton) {
        datePicker.isHidden = !datePicker.isHidden
        if datePicker.isHidden {
                     imgArrow.image = #imageLiteral(resourceName: "downArrow")
            upparView.backgroundColor = .white

        }else{
            imgArrow.image = #imageLiteral(resourceName: "upArrowGray")
            upparView.backgroundColor = .lightGray
        }
        
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        labelDate.text = dateFormatter.string(from: sender.date)
        
    }
}
