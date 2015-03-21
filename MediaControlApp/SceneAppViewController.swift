//
//  SceneAppViewController.swift
//  MediaControlApp
//
//  Created by Joel Angelone on 2/15/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit
import MediaControlKit

class SceneAppViewController: SceneViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Media Control"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActiveNotification:"), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func applicationWillResignActiveNotification(notification: NSNotification) {
        sceneController?.disconnectHosts()
    }
}

