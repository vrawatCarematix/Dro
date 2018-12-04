//
//  CustomAlert.swift
//  blip
//
//  Created by Carematix on 29/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class CustomActivityIndicator: UIView {
    
    @IBOutlet var trainlingSpace: NSLayoutConstraint!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate static var sharedInstance: CustomActivityIndicator{
        struct Static {
            static let instance = CustomActivityIndicator.instanceFromNib()
        }
        return Static.instance
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate class func instanceFromNib() -> CustomActivityIndicator {
        let view = UINib(nibName: "CustomActivityIndicator", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomActivityIndicator
        view.frame = UIScreen.main.bounds
        view.message.setCustomFont()
        view.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2);
        //view.activityIndicator.startAnimating()
        return view
    }
    
    
    fileprivate class func instanceFromNib(title : String , message : String ,type : AlertType ) -> UIView {
        let view = UINib(nibName: "CustomActivityIndicator", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomActivityIndicator
        view.frame = UIScreen.main.bounds
        view.message.text = message
        view.message.setCustomFont()
        return view
    }
    
    class func stopAnimating() {
        CustomActivityIndicator.sharedInstance.activityIndicator.stopAnimating()
        CustomActivityIndicator.sharedInstance.removeFromSuperview()

    }
    
    class func startAnimating(message: String) {
        let activityIndicator =  CustomActivityIndicator.sharedInstance
        activityIndicator.message.text = message
        if message.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            activityIndicator.trainlingSpace.constant = 0
        }else{
            activityIndicator.trainlingSpace.constant = 30
        }
        if sharedInstance.activityIndicator.isAnimating {
            
        }else{
            sharedInstance.activityIndicator.startAnimating()
            UIApplication.shared.keyWindow?.addSubview(activityIndicator)
        }
     
       
    }
}
