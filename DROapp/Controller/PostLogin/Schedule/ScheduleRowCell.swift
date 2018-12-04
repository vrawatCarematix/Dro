//
//  ScheduleRowCell.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ScheduleRowCell: UITableViewCell {
    @IBOutlet var progrssStatusView: UIView!

    @IBOutlet var progressView: UICircularProgressRingView!
    @IBOutlet var buttonStart: UIButton!
    @IBOutlet var labelType: UILabel!
    @IBOutlet var labelDue: UILabel!
    @IBOutlet var labelTitle: UILabel!
    
    @IBOutlet var startButtonTopConstant: NSLayoutConstraint!
    @IBOutlet var startButtonBottomConstant: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.setCustomFont()
        labelType.setCustomFont()
        labelDue.setCustomFont()
        
        buttonStart.setCustomFont()
        if UIDevice.current.userInterfaceIdiom == .pad {
            progressView.outerRingWidth = 4
            progressView.innerRingWidth = 4
        }else{
            progressView.outerRingWidth = 2
            progressView.innerRingWidth = 2
        }
        progressView.startAngle = 270
        progressView.ringStyle = .ontop
        progressView.value = 0
       // progressView.showFloatingPoint = true
       // progressView.decimalPlaces =
        progressView.font = labelDue.font
        progressView.ringStyle = .ontop
        // Initialization code
    }

}
