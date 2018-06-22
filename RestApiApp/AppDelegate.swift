//
//  AppDelegate.swift
//  RestApiApp
//
//  Created by Nele Müller on 08.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - Test Setup
        
        if (ProcessInfo.processInfo.environment["TestCall"] == "true") {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            guard let initialViewController = storyboard.instantiateInitialViewController() as? SpeciesViewController else {
                print("ViewController couldn't be instatiated.")
                return false
            }

            guard let fileUrl = ProcessInfo.processInfo.environment["Filename"] else {
                print("No Filename received at launch for testing.")
                return false
            }
            
            let mockNetworking = MockNetworking()
            let mockNetworkManager = NetworkManager(networking: mockNetworking, endpoint: fileUrl)
            initialViewController.changeNetworkManager(to: mockNetworkManager)
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
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

