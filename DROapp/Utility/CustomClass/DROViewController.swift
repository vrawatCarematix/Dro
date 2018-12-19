//
//  DROViewController.swift
//  DROapp
//
//  Created by Carematix on 17/12/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class DROViewController: UIViewController {

    var defaultCornerRadius = CGFloat(7.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad{
            defaultCornerRadius = 15.0
        }else{
            defaultCornerRadius = 7.0
        }
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
