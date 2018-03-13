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
    
    fileprivate var outputStream: OutputStream?
    fileprivate var inputStream: InputStream?
    
    fileprivate var socketQueue: DispatchQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Media Control"
        
        socketQueue = DispatchQueue(label: "com.draken.MediaControl.socket", qos: .userInteractive, attributes: [], autoreleaseFrequency: .workItem, target: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationWillResignActiveNotification(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        receiverPowerButton = mediaControlButton()
        receiverPowerButton.setTitle("Receiver Power", for: UIControlState())
        view.addSubview(receiverPowerButton)
        
        tvPowerButton = mediaControlButton()
        tvPowerButton.setTitle("TV Power", for: UIControlState())
        tvPowerButton.addTarget(self, action: #selector(ViewController.tvPower), for: .touchUpInside)
        view.addSubview(tvPowerButton)
        
        tvInputButton = mediaControlButton()
        tvInputButton.setTitle("TV Input", for: UIControlState())
        view.addSubview(tvInputButton)
        
        receiverInputButton = mediaControlButton()
        receiverInputButton.setTitle("Receiver Input", for: UIControlState())
        view.addSubview(receiverInputButton)
        
        volumeDownButton = mediaControlButton()
        volumeDownButton.setTitle("Volume Down", for: UIControlState())
        volumeDownButton.addTarget(self, action: #selector(ViewController.volumeDown), for: .touchUpInside)
        view.addSubview(volumeDownButton)
        
        volumeUpButton = mediaControlButton()
        volumeUpButton.setTitle("Volume Up", for: UIControlState())
        volumeUpButton.addTarget(self, action: #selector(ViewController.volumeUp), for: .touchUpInside)
        view.addSubview(volumeUpButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        socketQueue.async(execute: { () -> Void in
            self.openConnectionIfNecessary()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
        let totalButtonHeight = bounds.height - totalPadding
        
        let buttonHeight = totalButtonHeight / MediaControlNumberOfRows
        let largeButtonWidth = bounds.width - MediaControlButtonPadding * 2.0
        let smallButtonWidth = (bounds.width - MediaControlButtonPadding * 3) / 2.0
        
        let centerButtonOriginX = bounds.midX
        let leftButtonOriginX = MediaControlButtonPadding + smallButtonWidth / 2.0
        let rightButtonOriginX = bounds.width - MediaControlButtonPadding - smallButtonWidth / 2.0
        
        let largeButtonBounds = CGRect(x: 0, y: 0, width: largeButtonWidth, height: buttonHeight)
        let smallButtonBounds = CGRect(x: 0, y: 0, width: smallButtonWidth, height: buttonHeight)
        
        let receiverPowerButtonOriginY = mediaControlOriginYForRow(MediaControlReceiverPowerRow, buttonHeight: buttonHeight)
        
        receiverPowerButton.bounds = largeButtonBounds
        receiverPowerButton.center = CGPoint(x: centerButtonOriginX, y: receiverPowerButtonOriginY)
        
        let inputOriginY = mediaControlOriginYForRow(MediaControlInputRow, buttonHeight: buttonHeight)
        
        tvInputButton.bounds = smallButtonBounds
        tvInputButton.center = CGPoint(x: leftButtonOriginX, y: inputOriginY)
        
        receiverInputButton.bounds = smallButtonBounds
        receiverInputButton.center = CGPoint(x: rightButtonOriginX, y: inputOriginY)
        
        let tvPowerButtonOriginY = mediaControlOriginYForRow(MediaControlTVPowerRow, buttonHeight: buttonHeight)
        
        tvPowerButton.bounds = largeButtonBounds
        tvPowerButton.center = CGPoint(x: centerButtonOriginX, y: tvPowerButtonOriginY)
        
        let volumeButtonOriginY = mediaControlOriginYForRow(MediaControlVolumeRow, buttonHeight: buttonHeight)
        
        volumeDownButton.bounds = smallButtonBounds
        volumeDownButton.center = CGPoint(x: leftButtonOriginX, y: volumeButtonOriginY)
        
        volumeUpButton.bounds = smallButtonBounds
        volumeUpButton.center = CGPoint(x: rightButtonOriginX, y: volumeButtonOriginY)
    }
    
    @objc func tvPower() {
        sendMessage("sendir,1:2,1,38000,1,69,343,172,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,21,21,64,21,64,21,21,21,64,21,64,21,64,21,64,21,64,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,64,21,64,21,64,21,64,21,1524,343,86,21,3670\r")
    }
    
    @objc func volumeUp() {
        sendMessage("sendir,1:1,1,37993,1,1,341,171,22,21,22,63,22,21,22,21,22,63,22,21,22,63,22,63,22,63,22,21,22,63,22,63,22,21,22,63,22,63,22,21,22,21,22,63,22,21,22,21,22,21,22,21,22,21,22,21,22,63,22,21,22,63,22,63,22,63,22,63,22,63,22,63,22,1475,341,171,22,21,22,63,22,21,22,21,22,63,22,21,22,63,22,63,22,63,22,21,22,63,18,4863\r")
    }
    
    @objc func volumeDown() {
        sendMessage("sendir,1:1,1,37993,1,1,22,1475,341,171,22,21,22,63,22,21,22,21,22,63,22,21,22,63,22,63,22,63,22,21,22,63,22,63,22,21,22,63,22,63,22,21,22,63,22,63,22,21,22,21,22,21,22,21,22,21,22,21,22,21,22,21,22,63,22,63,22,63,22,63,22,63,22,63,22,4863\r")
    }
    
    func sendMessage(_ message: String) {
        socketQueue.async(execute: { () -> Void in
            self.openConnectionIfNecessary()
            self.writeMessage(message)
        })
    }
    
    func openConnectionIfNecessary() {
        if outputStream == nil || outputStream?.streamStatus == .closed || outputStream?.streamStatus == .error {
            Stream.getStreamsToHost(withName: MediaControlHostName, port: MediaControlPort, inputStream: &inputStream, outputStream: &outputStream)
            outputStream?.schedule(in: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
            inputStream?.schedule(in: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
            outputStream?.open()
        }
    }
    
    func closeConnectionIfNecessary() {
        outputStream?.close()
        outputStream = nil
    }
    
    func writeMessage(_ message: String) {
        if let encodedMessage = message.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            outputStream?.write((encodedMessage as NSData).bytes.bindMemory(to: UInt8.self, capacity: encodedMessage.count), maxLength: encodedMessage.count)
        }
    }
    
    func mediaControlButton() -> UIButton {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        button.setTitleColor(UIColor(white: 0.8, alpha: 1.0), for: UIControlState())
        button.addTarget(self, action: #selector(ViewController.mediaControlButtonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(ViewController.mediaControlButtonUnpressed(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(ViewController.mediaControlButtonUnpressed(_:)), for: .touchUpOutside)
                button.addTarget(self, action: #selector(ViewController.mediaControlButtonUnpressed(_:)), for: .touchCancel)
        return button
    }
    
    func mediaControlOriginYForRow(_ row: CGFloat, buttonHeight: CGFloat) -> CGFloat {
        return MediaControlButtonPadding + (MediaControlButtonPadding + buttonHeight) * row + buttonHeight / 2.0
    }
    
    @objc func mediaControlButtonPressed(_ button: UIButton) {
        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    @objc func mediaControlButtonUnpressed(_ button: UIButton) {
        UIView.animate(withDuration: 0.07, animations: { () -> Void in
            button.transform = CGAffineTransform.identity
        })
    }
    
    @objc func applicationWillResignActiveNotification(_ notification: Notification) {
        closeConnectionIfNecessary()
    }
}

