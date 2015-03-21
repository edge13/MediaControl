//
//  SceneWidgetViewController.swift
//  MediaControlExtension
//
//  Created by Joel Angelone on 2/27/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit
import NotificationCenter
import MediaControlKit

class SceneWidgetViewController: SceneViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSizeMake(0, 300)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
}
