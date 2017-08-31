//
//  AppDelegate.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 31/07/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit
import CoreData
import SideMenuController
import Firebase
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        FirebaseApp.configure()
        
        GMSPlacesClient.provideAPIKey("AIzaSyCkkCA9n2NkfjcNPdiwu_hZj3-SCGUzv3g")
        //GMSServices.provideAPIKey("AIzaSyCkkCA9n2NkfjcNPdiwu_hZj3-SCGUzv3g")
        ///
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 280
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        ///
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.backgroundColor = .white
        
        UINavigationBar.appearance().barTintColor = CommonHelper.mainColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        configureRootViewController()
        return true
    }

     func configureRootViewController() {
        
         let newWindow = UIWindow(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.bool(forKey: "isNotFirstTime_ihelper") {
            newWindow.rootViewController = UIStoryboard(name: Screens.SideMenu.name(), bundle: nil).instantiateInitialViewController()
        }
        else{
            guard let viewController = UIStoryboard(name: Screens.Welcome.name(), bundle: nil).instantiateInitialViewController() as? WelcomeViewController
                else{
                    return
            }
            viewController.delegate = self
            newWindow.rootViewController = viewController
        }
        newWindow.makeKeyAndVisible()
        newWindow.alpha = 0.0
        
        UIView.animate(withDuration: 0.33, animations: {
            newWindow.alpha = 1.0
            
        }, completion: { _ in
            self.window = newWindow
        })
    }
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "I-Helper")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - WelcomeViewControllerDelegate
extension AppDelegate: WelcomeViewControllerDelegate {
    
    public func welcomeViewControllerDonePressed(_ controller: WelcomeViewController) {
        
        //SetUpSideMenuController()
        UserDefaults.standard.set(true, forKey: "isNotFirstTime_ihelper")
        configureRootViewController()
    }


}



