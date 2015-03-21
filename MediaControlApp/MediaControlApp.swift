//
//  MediaControlApp.swift
//  MediaControlApp
//
//  Created by Joel Angelone on 2/14/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit
import MediaControlKit

@UIApplicationMain
class MediaControlApp: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let viewController = SceneAppViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = Appearance.darkGrayColor
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UIBarButtonItem.appearance().tintColor = Appearance.greenColor
        UILabel.appearance().textColor = Appearance.greenColor
        
        application.setStatusBarStyle(.LightContent, animated: false)
        
        return true
    }
}

