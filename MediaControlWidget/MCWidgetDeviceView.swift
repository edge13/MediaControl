//
//  MCDeviceControlView.swift
//  MediaControl
//
//  Created by Joel Angelone on 9/20/14.
//  Copyright (c) 2014 Joel Angelone. All rights reserved.
//

import UIKit

class MCWidgetDeviceView: UIView {
    var host:String?
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    
    var deviceName:String? {
        didSet {
            if (deviceName == oldValue) {
                return
            }
            
            if (deviceName != nil) {
                if (deviceNameLabel == nil) {
                    deviceNameLabel = UILabel(frame: CGRectZero)
                    deviceNameLabel?.textColor = UIColor.whiteColor()
                    deviceNameLabel?.font = UIFont.boldSystemFontOfSize(18.0)
                    self.addSubview(deviceNameLabel!)
                }
                deviceNameLabel?.text = deviceName
            }
            else if (deviceNameLabel != nil) {
                deviceNameLabel?.removeFromSuperview()
                deviceNameLabel = nil
            }
            setNeedsLayout()
        }
    }

    var powerCommand:String? {
        didSet {
            if (powerCommand == oldValue) {
                return
            }
            
            if (powerCommand != nil) {
                if (powerButton == nil) {
                    powerButton = MCWidgetButton(frame: CGRectZero)
                    powerButton?.setImage(UIImage(named: "Power"), forState: .Normal)
                    powerButton?.addTarget(self, action: Selector("powerTapped:"), forControlEvents: .TouchDown)
                    self.addSubview(powerButton!)
                }
            }
            else if (powerButton != nil) {
                powerButton?.removeFromSuperview()
                powerButton = nil
            }
            setNeedsLayout()
        }
    }
    
    var volumeUpCommand:String? {
        didSet {
            if (volumeUpCommand == oldValue) {
                return
            }
            
            if (volumeUpCommand != nil) {
                if (volumeUpButton == nil) {
                    volumeUpButton = MCWidgetButton(frame: CGRectZero)
                    volumeUpButton?.setImage(UIImage(named: "VolumeUp"), forState: .Normal)
                    volumeUpButton?.addTarget(self, action: Selector("volumeUpTapped:"), forControlEvents: .TouchDown)
                    self.addSubview(volumeUpButton!)
                }
            }
            else if (volumeUpButton != nil) {
                volumeUpButton?.removeFromSuperview()
                volumeUpButton = nil
            }
            setNeedsLayout()
        }
    }
    
    var volumeDownCommand:String? {
        didSet {
            if (volumeDownCommand == oldValue) {
                return
            }
            
            if (volumeDownCommand != nil) {
                if (volumeDownButton == nil) {
                    volumeDownButton = MCWidgetButton(frame: CGRectZero)
                    volumeDownButton?.setImage(UIImage(named: "VolumeDown"), forState: .Normal)
                    volumeDownButton?.addTarget(self, action: Selector("volumeDownTapped:"), forControlEvents: .TouchDown)
                    self.addSubview(volumeDownButton!)
                }
            }
            else if (volumeDownButton != nil) {
                volumeDownButton?.removeFromSuperview()
                volumeDownButton = nil
            }
            setNeedsLayout()
        }
    }
    
    private var deviceNameLabel: UILabel?
    private var powerButton: MCWidgetButton?
    private var volumeUpButton: MCWidgetButton?
    private var volumeDownButton: MCWidgetButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonPadding:CGFloat = 6.0
        let buttonWidth = self.bounds.width / 6.0
        let buttonHeight = self.bounds.height - buttonPadding * 2.0
        var currentInset = self.bounds.width - buttonWidth - buttonPadding
        
        if (deviceNameLabel != nil) {
            let nameWidth = self.bounds.width / 2.0
            deviceNameLabel?.frame = CGRectMake(0, buttonPadding, nameWidth, buttonHeight)
        }
        
        if (powerButton != nil) {
            powerButton?.bounds = CGRectMake(0, 0, buttonWidth, buttonHeight)
            powerButton?.center = CGPointMake(currentInset + buttonWidth/2.0, buttonPadding + buttonHeight/2.0)
            currentInset -= buttonWidth
            currentInset -= buttonPadding
        }
        
        if (volumeUpButton != nil) {
            volumeUpButton?.bounds = CGRectMake(0, 0, buttonWidth, buttonHeight)
            volumeUpButton?.center = CGPointMake(currentInset + buttonWidth/2.0, buttonPadding + buttonHeight/2.0)
            currentInset -= buttonWidth
            currentInset -= buttonPadding
        }
        
        if (volumeDownButton != nil) {
            volumeDownButton?.bounds = CGRectMake(0, 0, buttonWidth, buttonHeight)
            volumeDownButton?.center = CGPointMake(currentInset + buttonWidth/2.0, buttonPadding + buttonHeight/2.0)
        }
    }
    
    func powerTapped(button: UIButton) {
        writeCommand(powerCommand!)
    }
    
    func volumeUpTapped(button: UIButton) {
        writeCommand(volumeUpCommand!)
    }
    
    func volumeDownTapped(button: UIButton) {
        writeCommand(volumeDownCommand!)
    }
    
    func writeCommand(command: String) {
        let message = command.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        NSStream.getStreamsToHostWithName(host!, port: MCCommandPort, inputStream: &inputStream, outputStream: &outputStream)
        
        outputStream!.open()
        outputStream?.write(UnsafePointer<UInt8>(message!.bytes), maxLength: message!.length)
        outputStream!.close()
    }
}
