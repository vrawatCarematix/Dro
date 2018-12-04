//
//  DropdownAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 20/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DropdownAnswerCell: UITableViewCell {
    
    @IBOutlet var upperView: UIView!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var imgArrow: UIImageView!
    @IBOutlet var labelSelected: UILabel!
    var dropdownValueArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelSelected.setCustomFont()
        
        picker.isHidden = true
        picker.dataSource = self

        picker.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func dataForDropdown(data : [String])  {
        dropdownValueArray = data
        labelSelected.text = dropdownValueArray[0]
        picker.reloadAllComponents()
    }
    @IBAction func showDropdown(_ sender: UIButton) {
        picker.isHidden = !picker.isHidden
        if picker.isHidden {
            imgArrow.image = #imageLiteral(resourceName: "downArrow")
            upperView.backgroundColor = .white
            
        }else{
            imgArrow.image = #imageLiteral(resourceName: "upArrowGray")
            upperView.backgroundColor = .lightGray
        }
        
    }
}

extension DropdownAnswerCell : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dropdownValueArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dropdownValueArray[row]
    }
}
extension DropdownAnswerCell : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelSelected.text = dropdownValueArray[row]
    }
}
