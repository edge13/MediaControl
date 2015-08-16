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
        
        volumeDownButton.titleLabel?.font = UIFont.systemFontOfSize(10.0)
        tvPowerButton.titleLabel?.font = UIFont.systemFontOfSize(10.0)
        volumeUpButton.titleLabel?.font = UIFont.systemFontOfSize(10.0)
    }
    
    override func layoutButtons() {
        let bounds = self.view.bounds

        let MediaControlWidgetPadding = CGFloat(6.0)
        let MediaControlWidgetNumberOfButtons = CGFloat(3.0)
        
        let totalPadding = MediaControlWidgetPadding * (MediaControlWidgetNumberOfButtons + 1)
        let buttonWidth = (CGRectGetWidth(bounds) - totalPadding) / MediaControlWidgetNumberOfButtons
        let buttonHeight = buttonWidth
        
        let preferredHeight = buttonHeight + 2 * MediaControlWidgetPadding
        
        preferredContentSize = CGSizeMake(CGRectGetWidth(bounds), preferredHeight)
        
        let buttonBounds = CGRectMake(0, 0, buttonWidth, buttonHeight)
        let buttonOriginY = MediaControlWidgetPadding + buttonHeight / 2.0
        
        let volumeDownButtonOriginX = MediaControlWidgetPadding + buttonWidth / 2.0
        
        volumeDownButton.bounds = buttonBounds
        volumeDownButton.center = CGPointMake(volumeDownButtonOriginX, buttonOriginY)
        
        let tvPowerButtonOriginX = CGRectGetMidX(bounds)
        
        tvPowerButton.bounds = buttonBounds
        tvPowerButton.center = CGPointMake(tvPowerButtonOriginX, buttonOriginY)
        
        let volumeUpButtonOriginX = CGRectGetWidth(bounds) - MediaControlWidgetPadding - buttonWidth / 2.0
        
        volumeUpButton.bounds = buttonBounds
        volumeUpButton.center = CGPointMake(volumeUpButtonOriginX, buttonOriginY)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
}
