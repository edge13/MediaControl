//
//  TodayViewController.swift
//  MediaControlWidget
//
//  Created by Joel Angelone on 9/20/14.
//  Copyright (c) 2014 Joel Angelone. All rights reserved.
//

import UIKit
import NotificationCenter

@objc(MCWidgetViewController)

class MCWidgetViewController: UIViewController, NCWidgetProviding {
    var livingRoomTVControlView: MCWidgetDeviceView?
    var receiverControlView: MCWidgetDeviceView?
    var bedroomTVControlView: MCWidgetDeviceView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        livingRoomTVControlView = MCWidgetDeviceView(frame: CGRectZero)
        livingRoomTVControlView?.deviceName = "Living Room TV"
        livingRoomTVControlView?.host = MCHostLivingRoomTV
        livingRoomTVControlView?.powerCommand = MCCommandLivingRoomTVPower
        self.view.addSubview(livingRoomTVControlView!)
        
        receiverControlView = MCWidgetDeviceView(frame: CGRectZero)
        receiverControlView?.deviceName = "Receiver"
        receiverControlView?.host = MCHostReceiver
        receiverControlView?.powerCommand = MCCommandReceiverPower
        receiverControlView?.volumeUpCommand = MCCommandReceiverVolumeUp
        receiverControlView?.volumeDownCommand = MCCommandReceiverVolumeDown
        self.view.addSubview(receiverControlView!)
        
        bedroomTVControlView = MCWidgetDeviceView(frame: CGRectZero)
        bedroomTVControlView?.deviceName = "Bedroom TV"
        bedroomTVControlView?.host = MCHostBedroomTV
        bedroomTVControlView?.powerCommand = MCCommandBedroomTVPower
        bedroomTVControlView?.volumeUpCommand = MCCommandBedroomTVVolumeUp
        bedroomTVControlView?.volumeDownCommand = MCCommandBedroomTVVolumeDown
        self.view.addSubview(bedroomTVControlView!)
        
        self.preferredContentSize = CGSizeMake(0, 150)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let deviceControlWidth = self.view.bounds.width
        let deviceControlHeight = self.view.bounds.height / 3.0
        
        livingRoomTVControlView?.frame = CGRectMake(0, 0, deviceControlWidth, deviceControlHeight)
        receiverControlView?.frame = CGRectMake(0, deviceControlHeight, deviceControlWidth, deviceControlHeight)
        bedroomTVControlView?.frame = CGRectMake(0, deviceControlHeight*2, deviceControlWidth, deviceControlHeight)
    }
}
