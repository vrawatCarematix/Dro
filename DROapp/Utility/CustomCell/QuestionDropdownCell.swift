//
//  QuestionDropdownCell.swift
//  DRO
//
//  Created by Carematix on 08/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import DropDown
class QuestionDropdownCell: UITableViewCell {

    @IBOutlet weak var dropDownButton: UIButton!
    
    var dropdownArray = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        dropDownButton.setCustomFont()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func showDropDown(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownButton // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dropdownArray
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          //  print("Selected item: \(item) at index: \(index)")
            self.dropDownButton.setTitle(item, for: .normal)
            dropDown.hide()
        }
        dropDown.show()

    }
}
