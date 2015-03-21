//
//  SceneView.swift
//  MediaControlKit
//
//  Created by Joel Angelone on 2/15/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit

public protocol SceneViewDelegate: class {
    func sceneViewDidTapCommand(sceneView: SceneView, command: Command)
}

public class SceneView: UIView {
    private var utilityButtons: Array<CommandButton>
    private var increaseButton: CommandButton?
    private var decreaseButton: CommandButton?
    private var sceneNameLabel: UILabel
    private var separatorView: UIView
    
    public weak var delegate: SceneViewDelegate?

    public init(scene: Scene) {
        utilityButtons = Array<CommandButton>()
        
        if let commands = scene.commands {
            for (_, command) in enumerate(commands) {
                if let type = command.type {
                    switch type {
                    case CommandType.Power:
                        let button = CommandButton(command: command)
                        utilityButtons.append(button)
                    case CommandType.VolumeUp:
                        increaseButton = CommandButton(command: command)
                    case CommandType.VolumeDown:
                        decreaseButton = CommandButton(command: command)
                    }
                }
            }
        }
        
        sceneNameLabel = UILabel(frame: CGRectZero)
        sceneNameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        sceneNameLabel.textColor = Appearance.greenColor
        sceneNameLabel.text = scene.dispayName
        
        separatorView = UIView(frame: CGRectZero)
        separatorView.backgroundColor = Appearance.greenColor
        
        super.init(frame: CGRectZero)
        
        addSubview(sceneNameLabel)
        addSubview(separatorView)
        
        if let increaseButton = increaseButton {
            increaseButton.addTarget(self, action: Selector("buttonTapped:"), forControlEvents: UIControlEvents.TouchDown)
            addSubview(increaseButton)
        }
        if let decreaseButton = decreaseButton {
            decreaseButton.addTarget(self, action: Selector("buttonTapped:"), forControlEvents: UIControlEvents.TouchDown)
            addSubview(decreaseButton)
        }
        
        for (_, utilityButton) in enumerate(utilityButtons) {
            utilityButton.addTarget(self, action: Selector("buttonTapped:"), forControlEvents: UIControlEvents.TouchDown)
            addSubview(utilityButton)
        }
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        sceneNameLabel.sizeToFit()
        
        let scenePadding = CGRectGetHeight(bounds) / 10.0
        let sceneHeaderHeight = CGRectGetHeight(bounds) / 4.0
        let sceneHeaderBaseline = sceneHeaderHeight / 2.0
        
        let utilityButtonBounds = CGRectMake(0, 0, sceneHeaderHeight, sceneHeaderHeight)
        
        var x = scenePadding
        
        for (index, utilityButton) in enumerate(utilityButtons) {
            utilityButton.bounds = utilityButtonBounds
            utilityButton.center = CGPointMake(x + CGRectGetMidX(utilityButtonBounds), sceneHeaderBaseline)
            
            x += CGFloat(index + 1) * sceneHeaderHeight + scenePadding
        }
        
        sceneNameLabel.center = CGPointMake(x + CGRectGetMidX(sceneNameLabel.bounds), sceneHeaderBaseline)
        
        let separatorWidth = CGRectGetWidth(bounds) - x - CGRectGetWidth(sceneNameLabel.bounds) - scenePadding * 2
        
        separatorView.bounds = CGRectMake(0, 0, separatorWidth, 1)
        separatorView.center = CGPointMake(CGRectGetWidth(bounds) - CGRectGetMidX(separatorView.bounds) - scenePadding, sceneHeaderBaseline)
        
        let buttonBounds = CGRectMake(0, 0, CGRectGetMidX(bounds), CGRectGetHeight(bounds) - sceneHeaderHeight - scenePadding * 2)
        let buttonY = CGRectGetMidY(buttonBounds) + sceneHeaderHeight + scenePadding
        
        if let decreaseButton = decreaseButton {
            decreaseButton.bounds = buttonBounds
            decreaseButton.center = CGPointMake(CGRectGetMidX(buttonBounds), buttonY)
        }
        
        if let increaseButton = increaseButton {
            increaseButton.bounds = buttonBounds
            increaseButton.center = CGPointMake(CGRectGetWidth(bounds) - CGRectGetMidX(buttonBounds), buttonY)
        }
    }
    
    func buttonTapped(button: CommandButton) {
        delegate?.sceneViewDidTapCommand(self, command: button.command)
    }
}
