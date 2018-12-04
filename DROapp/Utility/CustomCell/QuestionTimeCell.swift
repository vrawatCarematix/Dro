//
//  QuestionTimeCell.swift
//  DRO
//
//  Created by Carematix on 07/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class QuestionTimeCell: UITableViewCell {
    @IBOutlet weak var timeTextField: UITextField!
    var datePicker : UIDatePicker?
    var toolBar = UIToolbar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        timeTextField.setCustomFont()

        doDatePicker()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func doDatePicker(){
        
        datePicker  = UIDatePicker()
        datePicker?.datePickerMode = UIDatePicker.Mode.time
        self.datePicker?.backgroundColor = UIColor.white
        
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
        self.timeTextField?.inputView = self.datePicker
        timeTextField.inputAccessoryView = self.toolBar
    }
    
    @objc func doneClick(sender : UIButton){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        self.timeTextField.text = dateFormatter.string(from: (datePicker?.date)!)
  
        timeTextField.resignFirstResponder()
    }
    
    @objc func cancelClick(sender : UIButton){
        timeTextField.resignFirstResponder()
    }
}
