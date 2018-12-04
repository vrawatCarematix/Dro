//
//  CustomAlert.swift
//  blip
//
//  Created by Carematix on 29/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

@objc protocol CustomErrorAlertDelegate {

    
    @objc optional func clickOnOKButton(_ sender:CustomErrorAlert)
}
class CustomErrorAlert: UIView {

    @IBOutlet weak var labalTitle: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var alertView: CardView!
    @IBOutlet weak var buttonOk: UIButton!
   weak var delegate: CustomErrorAlertDelegate?

    var message = String()
    override func awakeFromNib() {
        labelMessage.setCustomFont()
        buttonOk.setCustomFont()
        labalTitle.setCustomFont()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib(message : String) -> UIView {
       let view = UINib(nibName: "CustomErrorAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomErrorAlert
        view.frame = UIScreen.main.bounds
        view.labelMessage.text = message
       
        view.alertView.cornerRadius = 10.0
        view.alertView.clipsToBounds = true
        return view
    }
    class func instanceFromNib(title : String , message : String , okButtonTitle : String ,type : AlertType ) -> UIView {
        let view = UINib(nibName: "CustomErrorAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomErrorAlert
        view.frame = UIScreen.main.bounds
        view.labelMessage.text = message
       
        view.labalTitle.text = title
        if type == .error {
            view.labalTitle.textColor = UIColor.errorRed
        }
        view.buttonOk.setTitle(okButtonTitle, for: .normal)
        view.alertView.cornerRadius = 10.0
        view.alertView.clipsToBounds = true
        return view
    }
  
    @IBAction func okButtonClick(_ sender: UIButton) {
        if let delegat = delegate {
            delegat.clickOnOKButton!(self)
        }
        self.removeFromSuperview()
    }
}
