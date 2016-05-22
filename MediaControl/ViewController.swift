//
//  ViewController.swift
//  MediaControl
//
//  Created by Joel Angelone on 8/15/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit

let MediaControlButtonPadding = CGFloat(8.0)

let MediaControlHostName = "10.0.1.4"
let MediaControlPort = 4998

class ViewController: UIViewController {
    var volumeUpButton: UIButton!
    var volumeDownButton: UIButton!
    var tvInputButton: UIButton!
    var receiverInputButton: UIButton!
    var tvPowerButton: UIButton!
    var receiverPowerButton: UIButton!
    
    private var outputStream: NSOutputStream?
    private var inputStream: NSInputStream?
    
    private var socketQueue: dispatch_queue_t!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Media Control"
        
        let socketQueueAttributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
        socketQueue = dispatch_queue_create("com.draken.MediaControl.socket", socketQueueAttributes)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActiveNotification:"), name: UIApplicationWillResignActiveNotification, object: nil)
        
        receiverPowerButton = mediaControlButton()
        receiverPowerButton.setTitle("Receiver Power", forState: .Normal)
        view.addSubview(receiverPowerButton)
        
        tvPowerButton = mediaControlButton()
        tvPowerButton.setTitle("TV Power", forState: .Normal)
        tvPowerButton.addTarget(self, action: Selector("tvPower"), forControlEvents: .TouchUpInside)
        view.addSubview(tvPowerButton)
        
        tvInputButton = mediaControlButton()
        tvInputButton.setTitle("TV Input", forState: .Normal)
        view.addSubview(tvInputButton)
        
        receiverInputButton = mediaControlButton()
        receiverInputButton.setTitle("Receiver Input", forState: .Normal)
        view.addSubview(receiverInputButton)
        
        volumeDownButton = mediaControlButton()
        volumeDownButton.setTitle("Volume Down", forState: .Normal)
        volumeDownButton.addTarget(self, action: Selector("volumeDown"), forControlEvents: .TouchUpInside)
        view.addSubview(volumeDownButton)
        
        volumeUpButton = mediaControlButton()
        volumeUpButton.setTitle("Volume Up", forState: .Normal)
        volumeUpButton.addTarget(self, action: Selector("volumeUp"), forControlEvents: .TouchUpInside)
        view.addSubview(volumeUpButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutButtons()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_async(socketQueue, { () -> Void in
            self.openConnectionIfNecessary()
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        closeConnectionIfNecessary()
    }
    
    func layoutButtons() {
        let bounds = self.view.bounds
        
        let MediaControlNumberOfRows = CGFloat(4.0)
        let MediaControlReceiverPowerRow = CGFloat(0.0)
        let MediaControlInputRow = CGFloat(1.0)
        let MediaControlTVPowerRow = CGFloat(2.0)
        let MediaControlVolumeRow = CGFloat(3.0)
        
        let totalPadding = (MediaControlNumberOfRows + 1) * MediaControlButtonPadding
        let totalButtonHeight = CGRectGetHeight(bounds) - totalPadding
        
        let buttonHeight = totalButtonHeight / MediaControlNumberOfRows
        let largeButtonWidth = CGRectGetWidth(bounds) - MediaControlButtonPadding * 2.0
        let smallButtonWidth = (CGRectGetWidth(bounds) - MediaControlButtonPadding * 3) / 2.0
        
        let centerButtonOriginX = CGRectGetMidX(bounds)
        let leftButtonOriginX = MediaControlButtonPadding + smallButtonWidth / 2.0
        let rightButtonOriginX = CGRectGetWidth(bounds) - MediaControlButtonPadding - smallButtonWidth / 2.0
        
        let largeButtonBounds = CGRectMake(0, 0, largeButtonWidth, buttonHeight)
        let smallButtonBounds = CGRectMake(0, 0, smallButtonWidth, buttonHeight)
        
        let receiverPowerButtonOriginY = mediaControlOriginYForRow(MediaControlReceiverPowerRow, buttonHeight: buttonHeight)
        
        receiverPowerButton.bounds = largeButtonBounds
        receiverPowerButton.center = CGPointMake(centerButtonOriginX, receiverPowerButtonOriginY)
        
        let inputOriginY = mediaControlOriginYForRow(MediaControlInputRow, buttonHeight: buttonHeight)
        
        tvInputButton.bounds = smallButtonBounds
        tvInputButton.center = CGPointMake(leftButtonOriginX, inputOriginY)
        
        receiverInputButton.bounds = smallButtonBounds
        receiverInputButton.center = CGPointMake(rightButtonOriginX, inputOriginY)
        
        let tvPowerButtonOriginY = mediaControlOriginYForRow(MediaControlTVPowerRow, buttonHeight: buttonHeight)
        
        tvPowerButton.bounds = largeButtonBounds
        tvPowerButton.center = CGPointMake(centerButtonOriginX, tvPowerButtonOriginY)
        
        let volumeButtonOriginY = mediaControlOriginYForRow(MediaControlVolumeRow, buttonHeight: buttonHeight)
        
        volumeDownButton.bounds = smallButtonBounds
        volumeDownButton.center = CGPointMake(leftButtonOriginX, volumeButtonOriginY)
        
        volumeUpButton.bounds = smallButtonBounds
        volumeUpButton.center = CGPointMake(rightButtonOriginX, volumeButtonOriginY)
    }
    
    func tvPower() {
        sendMessage("sendir,1:2,1,38000,1,69,343,172,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,21,21,64,21,64,21,21,21,64,21,64,21,64,21,64,21,64,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,64,21,64,21,64,21,64,21,1524,343,86,21,3670\r")
    }
    
    func volumeUp() {
        sendMessage("sendir,1:1,1,37993,1,1,341,171,22,21,22,63,22,21,22,21,22,63,22,21,22,63,22,63,22,63,22,21,22,63,22,63,22,21,22,63,22,63,22,21,22,21,22,63,22,21,22,21,22,21,22,21,22,21,22,21,22,63,22,21,22,63,22,63,22,63,22,63,22,63,22,63,22,1475,341,171,22,21,22,63,22,21,22,21,22,63,22,21,22,63,22,63,22,63,22,21,22,63,18,4863\r")
    }
    
    func volumeDown() {
        sendMessage("sendir,1:1,1,37993,1,1,22,1475,341,171,22,21,22,63,22,21,22,21,22,63,22,21,22,63,22,63,22,63,22,21,22,63,22,63,22,21,22,63,22,63,22,21,22,63,22,63,22,21,22,21,22,21,22,21,22,21,22,21,22,21,22,21,22,63,22,63,22,63,22,63,22,63,22,63,22,4863\r")
    }
    
    func sendMessage(message: String) {
        dispatch_async(socketQueue, { () -> Void in
            self.openConnectionIfNecessary()
            self.writeMessage(message)
        })
    }
    
    func openConnectionIfNecessary() {
        if outputStream == nil || outputStream?.streamStatus == .Closed || outputStream?.streamStatus == .Error {
            NSStream.getStreamsToHostWithName(MediaControlHostName, port: MediaControlPort, inputStream: &inputStream, outputStream: &outputStream)
            outputStream?.scheduleInRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            inputStream?.scheduleInRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            outputStream?.open()
        }
    }
    
    func closeConnectionIfNecessary() {
        outputStream?.close()
        outputStream = nil
    }
    
    func writeMessage(message: String) {
        if let encodedMessage = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            outputStream?.write(UnsafePointer<UInt8>(encodedMessage.bytes), maxLength: encodedMessage.length)
        }
    }
    
    func mediaControlButton() -> UIButton {
        let button = UIButton(frame: CGRectZero)
        button.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        button.setTitleColor(UIColor(white: 0.8, alpha: 1.0), forState: .Normal)
        button.addTarget(self, action: Selector("mediaControlButtonPressed:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("mediaControlButtonUnpressed:"), forControlEvents: .TouchUpInside)
        button.addTarget(self, action: Selector("mediaControlButtonUnpressed:"), forControlEvents: .TouchUpOutside)
                button.addTarget(self, action: Selector("mediaControlButtonUnpressed:"), forControlEvents: .TouchCancel)
        return button
    }
    
    func mediaControlOriginYForRow(row: CGFloat, buttonHeight: CGFloat) -> CGFloat {
        return MediaControlButtonPadding + (MediaControlButtonPadding + buttonHeight) * row + buttonHeight / 2.0
    }
    
    func mediaControlButtonPressed(button: UIButton) {
        button.transform = CGAffineTransformMakeScale(0.9, 0.9)
    }
    
    func mediaControlButtonUnpressed(button: UIButton) {
        UIView.animateWithDuration(0.07, animations: { () -> Void in
            button.transform = CGAffineTransformIdentity
        })
    }
    
    func applicationWillResignActiveNotification(notification: NSNotification) {
        closeConnectionIfNecessary()
    }
}

