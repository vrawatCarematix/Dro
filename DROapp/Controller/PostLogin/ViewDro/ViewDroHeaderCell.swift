//
//  ViewDroHeaderCell.swift
//  DROapp
//
//  Created by Carematix on 10/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

class ViewDroHeaderCell: UITableViewCell {
    
    //MARK:- Outlet

    @IBOutlet var labelDroClosed: UILabel!
    @IBOutlet var droCollection: UICollectionView!
    
    //MARK:- Variables
    var titleArray = ["Assigned", "Completed" , "Active" , "Declined" ,"Expired"]
    let imageArray = [#imageLiteral(resourceName: "assigned"), #imageLiteral(resourceName: "completedDash") , #imageLiteral(resourceName: "activated") , #imageLiteral(resourceName: "declinedDasboard") , #imageLiteral(resourceName: "expired")]
    
    //MARK:- Cell Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        labelDroClosed.setCustomFont()
        droCollection.dataSource = self
        droCollection.delegate = self
    }
    
    func configCell()  {
        titleArray = [kAssigned.localisedString().capitalized, kCompleted.localisedString().capitalized , kActive.localisedString().capitalized , kDeclined.localisedString().capitalized  ,
            kExpired.localisedString().capitalized]
        droCollection.reloadData()
        
    }
}


//MARK:- UICollectionViewDataSource

extension ViewDroHeaderCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.ViewDroCollectionViewCell, for: indexPath) as! ViewDroCollectionViewCell
        cell.imgStatus.image = imageArray[indexPath.row]
        cell.labelTitle.text = titleArray[indexPath.row]
        
        var newCompleteCount = DatabaseHandler.getCompleteSurveyCount()
        if let oldCompleteCount = kUserDefault.value(forKey: kOldCompleteCount) as? Int {
            newCompleteCount = newCompleteCount - oldCompleteCount
        }
        var newExpiredCount = DatabaseHandler.getExpiredSurveyCount()
        if let oldExpiredCount = kUserDefault.value(forKey: kOldExpiredCount) as? Int {
            newExpiredCount = newExpiredCount - oldExpiredCount
        }
        var newDeclineCount = DatabaseHandler.getDeclinedSurveyCount()
        if let oldDeclineCount = kUserDefault.value(forKey: kOldDeclineCount) as? Int {
            newDeclineCount = newDeclineCount - oldDeclineCount
        }
        
        var newAssignCount = DatabaseHandler.getAssignSurveyCount()
        if let newCompleteCount = kUserDefault.value(forKey: kOldAssignCount) as? Int {
            newAssignCount = newAssignCount - newCompleteCount
        }
        
        let activeCount = DatabaseHandler.getActiveSurveyCount()

        if indexPath.item == 0{
            if let assigned = kUserDefault.value(forKey: kassigned) as? Int {
                cell.labelNumber.text = "\(assigned + newAssignCount)"
            }else{
                cell.labelNumber.text = "\(newAssignCount)"
            }
        }else if indexPath.item == 1{
            if let completed = kUserDefault.value(forKey: kcompleted) as? Int {
                cell.labelNumber.text = "\(completed + newCompleteCount)"
            }else{
                cell.labelNumber.text = "\(newCompleteCount)"
                
            }
        }else if indexPath.item == 2{
//            if let active = kUserDefault.value(forKey: kactive) as? Int {
//                cell.labelNumber.text = "\(activeCount)"
//            }else{
//                cell.labelNumber.text = "\(0)"
//            }
            cell.labelNumber.text = "\(activeCount)"

        }else if indexPath.item == 3{
            if let declined = kUserDefault.value(forKey: kdeclined) as? Int {
                cell.labelNumber.text = "\(declined + newDeclineCount)"
            }else{
                cell.labelNumber.text = "\(newDeclineCount)"
            }
        }else{
            if let expired = kUserDefault.value(forKey: kexpired) as? Int {
                cell.labelNumber.text = "\(expired + newExpiredCount)"
            }else{
                cell.labelNumber.text = "\(newExpiredCount)"
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
}


//MARK:- UICollectionViewDelegateFlowLayout

extension ViewDroHeaderCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
             return CGSize(width: collectionView.frame.size.width / 2.5 , height: collectionView.frame.size.width * 0.44 / 2.5)
        }
        
        return CGSize(width: collectionView.frame.size.width / 2.5 , height: collectionView.frame.size.width * 0.6 / 2.5)
    }
}
