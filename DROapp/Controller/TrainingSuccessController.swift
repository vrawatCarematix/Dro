//
//  TrainingSuccessControllerViewController.swift
//  DROapp
//
//  Created by Carematix on 08/11/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class TrainingSuccessController: UIViewController {

    @IBOutlet var buttonGoBack: UIButton!
    @IBOutlet var labelCongrats: UILabel!
    @IBOutlet var labelDescription: UILabel!
    
    var labelDescriptionText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelCongrats.setCustomFont()
        labelDescription.setCustomFont()
        buttonGoBack.setCustomFont()
        labelDescription.text = labelDescriptionText
        var backButtonTitle = "Back to Dashboard"
        if let screen =  kUserDefault.value(forKey: kRootScreen) as? String , screen == AppController.ScheduleController{
            backButtonTitle = "Back to DRO Schedule"
        }
        buttonGoBack.setTitle(backButtonTitle, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func popToRoot(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
