////
//  AppDelegate.swift
//  DROapp
//
//  Created by Carematix on 04/07/18.
//  Copyright © 2018 Carematix. All rights reserved.
//https://medium.com/@lucasgoesvalle/custom-push-notification-with-image-and-interactions-on-ios-swift-4-ffdbde1f457

import UIKit
import IQKeyboardManagerSwift
import DropDown
import UserNotifications

import LGSideMenuController
import Fabric
import Crashlytics
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var reachability:Reachability!;
    
    var window: UIWindow?
    var reachabilty = Reachability()
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()
        reachabilty = Reachability.forInternetConnection()
        NotificationCenter.default.addObserver(self, selector: #selector(checkForReachability(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil);
        
        self.reachability = Reachability.forInternetConnection()
        self.reachability.startNotifier()
        let lastVisit = Int(Date().timeIntervalSince1970)
        kUserDefault.set(lastVisit * 1000, forKey: klastVisitedDate)
        kUserDefault.set(englishJson, forKey: kDefaultEnglishDictionary)
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        if let appCurrentVersion = kUserDefault.value(forKey: kAppCurrentVersion) as? String , appCurrentVersion != appVersion {
            DatabaseHandler.deleteAllTableData()
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                UserDefaults.standard.removeObject(forKey: key)
            }
            kUserDefault.set(appVersion, forKey: kAppCurrentVersion)
          
        }else{
            DatabaseHandler.createDatabaseIfNeeded()
            kUserDefault.set(appVersion, forKey: kAppCurrentVersion)
        }
        
        
//        for family in UIFont.familyNames {
//            print("\(family)")
//            
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("   \(name)")
//            }
//        }
       
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            // Swift
            let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                    title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
                                                    title: "Delete", options: [.destructive])
            
            let textAction = UNTextInputNotificationAction(identifier: "Text", title: "Reply", options: [], textInputButtonTitle: "cool", textInputPlaceholder: "Enter")
            
            // Swift
            let category = UNNotificationCategory(identifier: "UYLReminderCategory",
                                                  actions: [snoozeAction,deleteAction, textAction],
                                                  intentIdentifiers: [], options: [])
            
            // Swift
            center.setNotificationCategories([category])
        }
       
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(#imageLiteral(resourceName: "back"), for: .normal, barMetrics: .default)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Checking if user already logged in or not
        if let loggedIn = kUserDefault.value(forKey: kLoggedIn) as? String, loggedIn == kYes {
            
            let rootViewController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.DroTabBarController) as! DroTabBarController
            let leftViewController = PostLoginStoryboard.instantiateViewController(withIdentifier: AppController.LeftViewController) as! LeftViewController
            let sideMenuController = LGSideMenuController(rootViewController: rootViewController,leftViewController: leftViewController, rightViewController: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                sideMenuController.leftViewWidth = UIScreen.main.bounds.size.width * 0.6
            }else{
                sideMenuController.leftViewWidth = UIScreen.main.bounds.size.width * 0.8
            }
            sideMenuController.leftViewPresentationStyle = .scaleFromBig;
            sideMenuController.rightViewWidth = 100.0;
            sideMenuController.leftViewPresentationStyle = .slideBelow;
            let navC = UINavigationController(rootViewController: sideMenuController)
            navC.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navC
        }else{
            let navC = MainStoryboard.instantiateViewController(withIdentifier: "DroNavigationController") as! DroNavigationController
            navC.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navC
        }

        self.window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

    
    @objc func checkForReachability(notification:NSNotification){
        
        //var networkReachability = Reachability.reachabilityForInternetConnection()
        //networkReachability.startNotifier()
        
        if let networkReachability = notification.object as? Reachability {
            let remoteHostStatus = networkReachability.currentReachabilityStatus()
            if (remoteHostStatus == NotReachable){
                print("Not Reachable")
            }else if (remoteHostStatus == ReachableViaWiFi){
                print("Reachable via Wifi")
                syncUserData()
            }else{
                syncUserData()
                print("Reachable")
            }
        }
    }
    
    func syncUserData(){
        if let loggedIn = kUserDefault.value(forKey: kLoggedIn) as? String, loggedIn == kYes {
            if CheckNetworkUsability.sharedInstance().checkInternetConnection() {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNetworkAvailable), object: nil, userInfo: nil)
                
                let viewcontroller =  UIViewController()
                viewcontroller.updateMessage({ (success, message) in
                    viewcontroller.updateDeclineSurvey({ (success, message) in
                        viewcontroller.uploadSurveyData({ (success, message) in
                            viewcontroller.getMessage(completionHandler: { (success,response , message) in
                                print(message)
                            })
                        })
                    })
                    
                })
            }
        }
    }
    
 
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print(token)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("here")
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent Method called")

    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("didReceive Method called")
        
        if response.actionIdentifier == "Snooze" {
            DispatchQueue.main.async(execute: {
                self.alertAction()
            })
        } else if response.actionIdentifier == "actionTwo" {
            
        } else if response.actionIdentifier == "actionThree" {
            
        }
        completionHandler()
    }
    func alertAction() {
        
        let alertController = UIAlertController(title: "Hello", message: "This is cool!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            // Do something with handler block
        }))
        
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.present(alertController, animated: true, completion: nil)
    }
}
