//
//  NotificationViewController.swift
//  DroNotificationContent
//
//  Created by Carematix on 04/12/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var declineButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
       // label.setCustomFont()
       // continueButton.setCustomFont()
       // declineButton.setCustomFont()
        declineButton.layer.cornerRadius = 7.0
        continueButton.layer.cornerRadius = 7.0

    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
      
        debugPrint("Respoinnse")
        
    }

    @IBAction func startSurvey(_ sender: UIButton) {
        debugPrint("frer")
    }
    
    @IBAction func declineSurvey(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            debugPrint("Ok button tapped")
        })
        
        let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
            debugPrint("Delete button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            debugPrint("Cancel button tapped")
        })

        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
