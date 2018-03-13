//
//  TodayViewController.swift
//  MediaControlWidget
//
//  Created by Joel Angelone on 8/15/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: ViewController, NCWidgetProviding {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeDownButton.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        tvPowerButton.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        volumeUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
    }
    
    override func layoutButtons() {
        let bounds = self.view.bounds

        let MediaControlWidgetPadding = CGFloat(12.0)
        let MediaControlWidgetNumberOfButtons = CGFloat(3.0)
        
        let totalPadding = MediaControlWidgetPadding * (MediaControlWidgetNumberOfButtons + 1)
        let buttonWidth = (bounds.width - totalPadding) / MediaControlWidgetNumberOfButtons
        let buttonHeight = buttonWidth * 0.75;
        
        let preferredHeight = buttonWidth + 2 * MediaControlWidgetPadding
        
        preferredContentSize = CGSize(width: bounds.width, height: preferredHeight)
        
        let buttonBounds = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        let buttonOriginY = MediaControlWidgetPadding + buttonHeight / 2.0
        
        let volumeDownButtonOriginX = MediaControlWidgetPadding + buttonWidth / 2.0
        
        volumeDownButton.bounds = buttonBounds
        volumeDownButton.center = CGPoint(x: volumeDownButtonOriginX, y: buttonOriginY)
        
        let tvPowerButtonOriginX = bounds.midX
        
        tvPowerButton.bounds = buttonBounds
        tvPowerButton.center = CGPoint(x: tvPowerButtonOriginX, y: buttonOriginY)
        
        let volumeUpButtonOriginX = bounds.width - MediaControlWidgetPadding - buttonWidth / 2.0
        
        volumeUpButton.bounds = buttonBounds
        volumeUpButton.center = CGPoint(x: volumeUpButtonOriginX, y: buttonOriginY)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
