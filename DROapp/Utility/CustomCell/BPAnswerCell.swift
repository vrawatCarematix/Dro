//
//  BPAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 07/09/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

@objc protocol BPAnswerCellDelegate {
    @objc func bp( answer: AnswersModel , cell: BPAnswerCell)
}
class BPAnswerCell: UITableViewCell {

    //MARK:- Outlet
    @IBOutlet var labelSlash: UILabel!
    @IBOutlet var systolicTextfield: UITextField!
    @IBOutlet var diastolicTextfield: UITextField!
    
    //MARK:- Variable

    weak var delegate: BPAnswerCellDelegate?
    var answer = AnswersModel()
    
    //MARK:- Cell Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        systolicTextfield.setCustomFont()
        diastolicTextfield.setCustomFont()
        systolicTextfield.delegate = self
        diastolicTextfield.delegate = self

        labelSlash.setCustomFont()

        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            if let delegate = self.delegate {
                delegate.bp(answer: answer, cell: self)
            }
        }
        // Configure the view for the selected state
    }

}

extension BPAnswerCell : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if textField == systolicTextfield {
            if let text = systolicTextfield.text , let systolic = Int(text + string) {
                if systolic > 250 {
                    if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                        visibleController.view.showToastAtCenter(toastMessage: "Systolic cannot be greater than 250", duration: 1.0)
                    }
                    return false
                }
            }
        }else{
            if let text = diastolicTextfield.text , let diastolic = Int(text + string) {
                if diastolic > 150 {
                    if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                        visibleController.view.showToastAtCenter(toastMessage: "Diastolic cannot be greater than 150", duration: 1.0)
                    }
                    return false
                }
            }
        }
        return true
    }
}
