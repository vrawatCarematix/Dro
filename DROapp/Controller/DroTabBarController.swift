//
//  DroTabBarController.swift
//  DROapp
//
//  Created by Carematix on 05/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit

let tabBarSelectedTextColor = UIColor(red: 0.0980, green: 0.6157, blue: 0.8588, alpha: 1.0)
class DroTabBarController: UITabBarController {
    
    let  arrayOfImageNameForSelectedState = ["schedule-active" , "view-dro-active","dashboard-active","message-active","study-active"]
    let  arrayOfImageNameForUnselectedState = ["schedule" , "view-dro","dashboard","message","study"]
    var tabBarTitles =  ["Schedule" , "View DROs" ,"Dashboard" ,"Message" ,"Study" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let languageCode = kUserDefault.value(forKey: kselectedLanguage) as? String , languageCode != "" , languageCode == "ES"{
            kUserDefault.set(spanishJson, forKey: kDefaultEnglishDictionary)
        }else{
            kUserDefault.set(englishJson, forKey: kDefaultEnglishDictionary)
        }
        var endTime = Int(Date().timeIntervalSince1970)
        endTime  += TimeZone.current.secondsFromGMT()
        let _ = DatabaseHandler.expireOldSuvey(endTime: endTime * 1000)
        let _ = DatabaseHandler.enableNewSuvey(startTime :endTime * 1000)
        
        kUserDefault.set(kYes, forKey: kLoggedIn)
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                if UIDevice().userInterfaceIdiom == .phone {
                    
                    switch UIScreen.main.nativeBounds.height {
                        
                    case 2436, 1792, 2688:
                        self.tabBar.items?[i].selectedImage = resizeImage(image: UIImage(named: imageNameForSelectedState)!, targetSize:                CGSize(width: UIScreen.main.bounds.size.width / 5  - 25 , height: CGFloat(self.view.getCustomFontSize(size: 0)) * 6)).withRenderingMode(.alwaysOriginal)
                        
                        self.tabBar.items?[i].image = resizeImage(image: UIImage(named: imageNameForUnselectedState)!, targetSize:   CGSize(width: UIScreen.main.bounds.size.width / 5 - 25 , height: CGFloat(self.view.getCustomFontSize(size: 0)) * 6)).withRenderingMode(.alwaysOriginal)
                        
                    default:
                        self.tabBar.items?[i].selectedImage = resizeImage(image: UIImage(named: imageNameForSelectedState)!, targetSize:                CGSize(width: UIScreen.main.bounds.size.width / 5  - 25, height: CGFloat( (self.view.getCustomFontSize(size: 7) * 6 )  -  (self.view.getCustomFontSize(size: 5) * 4 )))).withRenderingMode(.alwaysOriginal)
                        
                        self.tabBar.items?[i].image = resizeImage(image: UIImage(named: imageNameForUnselectedState)!, targetSize: CGSize(width: UIScreen.main.bounds.size.width / 5  - 25, height: CGFloat( (self.view.getCustomFontSize(size: 7) * 6 ) -  (self.view.getCustomFontSize(size: 5) * 4 )))).withRenderingMode(.alwaysOriginal)
                    }
                }else{
                    
                    self.tabBar.items?[i].setBadgeTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue: UIFont(name: kSFRegular, size: CGFloat(self.view.getCustomFontSize(size: 0)))!]), for: .selected)
                    
                    self.tabBar.items?[i].selectedImage = resizeImage(image: UIImage(named: imageNameForSelectedState)!, targetSize:                CGSize(width: UIScreen.main.bounds.size.width / 5  - 20 , height: CGFloat(self.view.getCustomFontSize(size: -6)) * 4)).withRenderingMode(.alwaysOriginal)
                    
                    self.tabBar.items?[i].image = resizeImage(image: UIImage(named: imageNameForUnselectedState)!, targetSize: CGSize(width: UIScreen.main.bounds.size.width / 5  - 40 , height: CGFloat(self.view.getCustomFontSize(size: -6)) * 4)).withRenderingMode(.alwaysOriginal)
                    
                }
            }
        }
        
        self.selectedIndex = 2
        if UIDevice().userInterfaceIdiom == .phone {
            
            
            switch UIScreen.main.nativeBounds.height {
            case 2436 , 1792 ,2688:
                UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 12)
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont(name: kSFRegular, size: CGFloat(self.view.getCustomFontSize(size: 9)))!], for: .normal)
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:tabBarSelectedTextColor ,NSAttributedString.Key.font: UIFont(name: kSFRegular, size: CGFloat(self.view.getCustomFontSize(size: 9)))!], for: .selected)
            default:
                UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -CGFloat(self.view.getCustomFontSize(size: -1)))
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont(name: kSFRegular, size: CGFloat(self.view.getCustomFontSize(size: 11)))!], for: .normal)
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:tabBarSelectedTextColor ,NSAttributedString.Key.font: UIFont(name: kSFRegular, size: CGFloat(self.view.getCustomFontSize(size: 11)))!], for: .selected)
            }
        }else{
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont(name: kSFRegular, size: CGFloat(self.view.getCustomFontSize(size: 4)))!], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:tabBarSelectedTextColor,NSAttributedString.Key.font: UIFont(name: kSFRegular, size: CGFloat(self.view.getCustomFontSize(size: 4)))!], for: .selected)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)
        setText()
    }
    
    @objc func setText()  {
        
      
         tabBarTitles =  [kSchedule.localisedString() ,kView_DROs.localisedString() ,kDashboard.localisedString() ,kMessages.localisedString() ,kStudy.localisedString()]

        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                self.tabBar.items![i].title = tabBarTitles[i]
                
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        var newImage = image

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            if UIDevice.current.userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2436, 1792, 2688:
                    let renderer = UIGraphicsImageRenderer(bounds:  CGRect(x: 0, y: -6, width: newSize.width, height: newSize.height + 6) , format: renderFormat)
                    newImage = renderer.image {
                        (context) in
                        image.draw(in: CGRect(x: 0, y: 0 , width: newSize.height , height: newSize.height ))
                    }
                default:
                        let renderer = UIGraphicsImageRenderer(bounds:  CGRect(x: 0, y: 0 , width: newSize.width, height: newSize.height + 4  ) , format: renderFormat)
                        newImage = renderer.image {
                            (context) in
                            image.draw(in: CGRect(x: 0, y: 0 , width: newSize.height , height: newSize.height ))
                    }                }
            }else{
                let renderer = UIGraphicsImageRenderer(bounds:  CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height ) , format: renderFormat)
                newImage = renderer.image {
                    (context) in
                    image.draw(in: CGRect(x: 0, y: 0 , width: newSize.height , height: newSize.height ))
                }
            }
           
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), false, 0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
   
    
}


extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436, 1792, 2688:
                sizeThatFits.height = CGFloat(self.getCustomFontSize(size: 10)) * 6
            default:
                sizeThatFits.height = CGFloat(self.getCustomFontSize(size: 8)) * 6
            }
        }else{
            sizeThatFits.height = CGFloat(self.getCustomFontSize(size: -4)) * 6
        }
        return sizeThatFits
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
