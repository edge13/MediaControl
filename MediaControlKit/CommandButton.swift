//
//  CommandButton.swift
//  MediaControlKit
//
//  Created by Joel Angelone on 2/15/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit

class CommandButton: UIButton {
    
    override var highlighted: Bool {
        set {
        }
        get {
            return false
        }
    }
    
    private(set) var command: Command
    
    init(command: Command) {
        self.command = command
        
        super.init(frame: CGRectZero)
        
        if let image = imageForCommandType(command.type) {
            imageView?.contentMode = .ScaleAspectFit
            setImage(image, forState: .Normal)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.bounds = bounds
        imageView?.center = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        UIView.performWithoutAnimation { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.85, 0.85)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        resetScale()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        resetScale()
    }
    
    private func resetScale() {
        UIView.animateWithDuration(0.07, animations: { () -> Void in
            self.transform = CGAffineTransformIdentity
        })
    }
    
    private func imageForCommandType(type: CommandType?) -> UIImage? {
        if let type = type {
            switch type {
            case .Power:
                return UIImage(named: "Power")
            case .VolumeDown:
                return UIImage(named: "VolumeDown")
            case .VolumeUp:
                return UIImage(named: "VolumeUp")
            }
        }
        return nil
    }
}
