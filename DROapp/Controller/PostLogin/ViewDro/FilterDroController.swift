//
//  FilterDroController.swift
//  DROapp
//
//  Created by Carematix on 03/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//
//Roboto-Regular


import UIKit

class FilterDroController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var labelSort: UILabel!
    @IBOutlet var buttonStatus: UIButton!
    @IBOutlet var buttonDesc: UIButton!
    @IBOutlet var buttonAsc: UIButton!
    @IBOutlet var labelExpired: UILabel!
    @IBOutlet var labelDeclined: UILabel!
    @IBOutlet var labelCompleted: UILabel!
    @IBOutlet var labelAll: UILabel!
    @IBOutlet var labelStatusTitle: UILabel!
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var labelDesc: UILabel!
    @IBOutlet var labelAsc: UILabel!
    @IBOutlet var buttonAll: UIButton!
    @IBOutlet var buttonCompleted: UIButton!
    @IBOutlet var buttonDeclined: UIButton!
    @IBOutlet var laelSortBy: UILabel!
    @IBOutlet var buttonReset: UIButton!
    @IBOutlet var buttonExpired: UIButton!
    
    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        applyButton.layer.cornerRadius = 5.0
        applyButton.setCustomFont()
        labelSort.setCustomFont()
        labelAsc.setCustomFont()
        labelDesc.setCustomFont()
        labelStatus.setCustomFont()
        labelStatusTitle.setCustomFont()
        labelAll.setCustomFont()
        labelCompleted.setCustomFont()
        labelDeclined.setCustomFont()
        labelExpired.setCustomFont()
        laelSortBy.setCustomFont()
        buttonReset.setCustomFont()
        setText()
    }
    
    func setText(){
        labelSort.text = kSort_Filter.localisedString()
        labelAsc.text = kDate_Time_Asc.localisedString()
        labelDesc.text = kDate_Time_Desc.localisedString()
        labelStatus.text = kStatus.localisedString()
        labelStatusTitle.text = kStatus.localisedString()
        labelAll.text = kAll.localisedString()
        labelCompleted.text = kCompleted.localisedString()
        labelDeclined.text = kDeclined.localisedString()
        labelExpired.text = kExpired.localisedString()
        laelSortBy.text = kSort_by.localisedString()
        buttonReset.setTitle(kReset.localisedString(), for: .normal)
        applyButton.setTitle(kApply.localisedString(), for: .normal)
    }


    override func viewWillAppear(_ animated: Bool) {
        if let droStatus = kUserDefault.value(forKey: kDroStatus) as? [String]{
            if  let status = droStatus.first , status == "All"{

            }else{
                for status in droStatus {
                    if status == "COMPLETED" {
                        buttonCompleted.isSelected = true
                    }
                    if status == "EXPIRED" {
                        buttonExpired.isSelected = true
                    }
                    if status == "DECLINED" {
                        buttonDeclined.isSelected = true
                    }
                }
            }
        }else{
            buttonAll.isSelected = true
            buttonCompleted.isSelected = true
            buttonDeclined.isSelected = true
            buttonExpired.isSelected = true
        }
        allSelected()
        checkSelected()
        deselectionSortButton()
        if let droSort = kUserDefault.value(forKey: kDroSort) as? String{
            if droSort == kDroAsc {
                buttonAsc.isSelected = true
                labelAsc.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)
            }else if droSort == kDroDsc{
                buttonDesc.isSelected = true
                labelDesc.font = UIFont(name: kSFSemibold, size: labelDesc.font.pointSize)
            }else{
                buttonStatus.isSelected = true
                labelStatus.font = UIFont(name: kSFSemibold, size: labelStatus.font.pointSize)
            }
        }else{
            buttonDesc.isSelected = true
            labelDesc.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)
        }
        kSFRegular
    }
    
    //MARK:- Button Action

    @IBAction func sortAsc(_ sender: UIButton) {
        deselectionSortButton()
        buttonAsc.isSelected = true
        labelAsc.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)
    }
    
    @IBAction func sortDesc(_ sender: UIButton) {
        deselectionSortButton()
        buttonDesc.isSelected = true
        labelDesc.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)

    }
    
    @IBAction func sortStatus(_ sender: UIButton) {
        deselectionSortButton()
        buttonStatus.isSelected = true
        labelStatus.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)
    }
    
   
    @IBAction func allSelect(_ sender: UIButton) {
        buttonAll.isSelected = !buttonAll.isSelected
        if buttonAll.isSelected {
            buttonAll.isSelected = true
            buttonCompleted.isSelected = true
            buttonDeclined.isSelected = true
            buttonExpired.isSelected = true
        }else{
            buttonAll.isSelected = false
            buttonCompleted.isSelected = false
            buttonDeclined.isSelected = false
            buttonExpired.isSelected = false
        }
        checkSelected()
    }
    
    
    @IBAction func completedSelect(_ sender: UIButton) {
//        if !buttonDeclined.isSelected && !buttonExpired.isSelected && buttonCompleted.isSelected {
//            return
//        }

        buttonCompleted.isSelected = !buttonCompleted.isSelected
        allSelected()
        checkSelected()
    }
    @IBAction func declineSelect(_ sender: UIButton) {
//        if buttonDeclined.isSelected && !buttonExpired.isSelected && !buttonCompleted.isSelected {
//            return
//        }
        buttonDeclined.isSelected = !buttonDeclined.isSelected
        allSelected()
        checkSelected()
    }
    
    
    @IBAction func expiredSelect(_ sender: UIButton) {
//        if !buttonDeclined.isSelected && buttonExpired.isSelected && !buttonCompleted.isSelected {
//            return
//        }
        buttonExpired.isSelected = !buttonExpired.isSelected
        allSelected()
        checkSelected()
    }
    
    @IBAction func resetAll(_ sender: UIButton) {
        deselectionSortButton()
        buttonDesc.isSelected = true
        labelDesc.font = UIFont(name: kSFSemibold, size: labelDesc.font.pointSize)
        buttonAll.isSelected = true
        buttonCompleted.isSelected = true
        buttonDeclined.isSelected = true
        buttonExpired.isSelected = true
        checkSelected()
    }
    
    @IBAction func applyFilter(_ sender: UIButton) {
        var droStatus = [String]()
        if buttonCompleted.isSelected {
            droStatus.append("COMPLETED")
        }
        if buttonExpired.isSelected {
            droStatus.append("EXPIRED")
        }
        if buttonDeclined.isSelected {
            droStatus.append("DECLINED")
        }
        if droStatus.count == 0 {
            droStatus.append("ALL")
        }
        kUserDefault.set(droStatus, forKey: kDroStatus)
        if buttonAsc.isSelected {
            kUserDefault.set(kDroAsc, forKey: kDroSort)
        }else if buttonDesc.isSelected {
            kUserDefault.set(kDroDsc, forKey: kDroSort)
        }else if buttonStatus.isSelected {
            kUserDefault.set(kSortStatus, forKey: kDroSort)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kReloadViewDroData), object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func deselectionStatusButton() {
        buttonAll.isSelected = false
        buttonCompleted.isSelected = false
        buttonDeclined.isSelected = false
        buttonExpired.isSelected = false
        checkSelected()
    }
    
    func deselectionSortButton() {
        buttonAsc.isSelected = false
        buttonDesc.isSelected = false
        buttonStatus.isSelected = false
        labelStatus.font = UIFont(name: kSFRegular, size: labelStatus.font.pointSize)
        labelDesc.font = UIFont(name: kSFRegular, size: labelDesc.font.pointSize)
        labelAsc.font = UIFont(name: kSFRegular, size: labelAsc.font.pointSize)
    }
    
    func checkSelected(){
        if buttonAll.isSelected{
            labelAll.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)
        }else{
            labelAll.font = UIFont(name: kSFRegular, size: labelAsc.font.pointSize)
        }
        
        if buttonCompleted.isSelected{
            labelCompleted.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)
        }else{
            labelCompleted.font = UIFont(name: kSFRegular, size: labelAsc.font.pointSize)
        }
        
        if buttonExpired.isSelected{
            labelExpired.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)
        }else{
            labelExpired.font = UIFont(name: kSFRegular, size: labelAsc.font.pointSize)
        }
        
        if buttonDeclined.isSelected{
            labelDeclined.font = UIFont(name: kSFSemibold, size: labelAsc.font.pointSize)
        }else{
            labelDeclined.font = UIFont(name: kSFRegular, size: labelAsc.font.pointSize)
        }

    }
    
    func allSelected() {
        if buttonDeclined.isSelected && buttonExpired.isSelected && buttonCompleted.isSelected {
            buttonAll.isSelected = true
        }else{
            buttonAll.isSelected = false
        }
    }
}
