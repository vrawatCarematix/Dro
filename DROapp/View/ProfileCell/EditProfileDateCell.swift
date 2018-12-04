//
//  EditProfileDateCell.swift
//  DROapp
//
//  Created by Carematix on 08/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

@objc protocol EditProfileDateCellDelegate {
    @objc func saveDate( date: String , cell: EditProfileDateCell)
}

class EditProfileDateCell: UITableViewCell {
    @IBOutlet var textfieldData: UITextField!
    @IBOutlet var labelTitle: UILabel!
    var datePicker = UIDatePicker()
    weak var delegate: EditProfileDateCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        textfieldData.setCustomFont()
        labelTitle.setCustomFont()
        textfieldData.delegate = self

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let label = UIBarButtonItem(title: "Date of Birth", style: .plain, target: self, action: nil);
        label.tintColor = .black

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
 toolbar.setItems([cancelButton,spaceButton,label,spaceButton, doneButton], animated: false)
        
        textfieldData.inputAccessoryView = toolbar
        textfieldData.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        textfieldData.text = formatter.string(from: datePicker.date)
        if let delegat = delegate {
            delegat.saveDate(date: formatter.string(from: datePicker.date), cell: self)
        }
        
       
        textfieldData.resignFirstResponder()
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)

    }
}
extension EditProfileDateCell : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDatePicker()
    }
}
