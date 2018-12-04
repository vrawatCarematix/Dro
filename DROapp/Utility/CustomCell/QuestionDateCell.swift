//
//  QuestionDateCell.swift
//  DRO
//
//  Created by Carematix on 07/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class QuestionDateCell: UITableViewCell {
    
    @IBOutlet weak var dateTextField: UITextField!
    
    var datePicker : UIDatePicker?
    var toolBar = UIToolbar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        dateTextField.setCustomFont()

        doDatePicker()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func doDatePicker(){
        
        datePicker  = UIDatePicker()
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.datePickerMode = UIDatePicker.Mode.date
        
        // ToolBar
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick(sender:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.toolBar.isHidden = false
        self.dateTextField?.inputView = self.datePicker
        self.dateTextField.inputAccessoryView = self.toolBar
    }
    
    @objc func doneClick(sender : UIButton){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dateTextField.text = dateFormatter.string(from: (datePicker?.date)!)
        dateTextField.resignFirstResponder()
    }
    @objc func cancelClick(sender : UIButton){
        
        datePicker?.isHidden = true
        self.toolBar.isHidden = true
        dateTextField.resignFirstResponder()
    }
}
