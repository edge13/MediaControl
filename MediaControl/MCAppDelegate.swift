//
//  AppDelegate.swift
//  MediaControl
//
//  Created by Joel Angelone on 9/20/14.
//  Copyright (c) 2014 Joel Angelone. All rights reserved.
//

import UIKit

@UIApplicationMain
class MCAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

