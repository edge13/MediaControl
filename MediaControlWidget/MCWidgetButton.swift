//
//  MCWidgetButton.swift
//  MediaControl
//
//  Created by Joel Angelone on 9/20/14.
//  Copyright (c) 2014 Joel Angelone. All rights reserved.
//

import UIKit

class MCWidgetButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        imageView?.contentMode = .ScaleAspectFit
        contentEdgeInsets = UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0)
        backgroundColor = UIColor.darkGrayColor()
        layer.cornerRadius = 5.0
        
        addTarget(self, action: Selector("animateButtonDown:"), forControlEvents: .TouchDown)
        addTarget(self, action: Selector("animateButtonUp:"), forControlEvents: .TouchUpInside)
        addTarget(self, action: Selector("animateButtonUp:"), forControlEvents: .TouchCancel)
    }

    func animateButtonDown(button: UIButton) {
        UIView.animateWithDuration(0.01, animations: { () -> Void in
            button.transform = CGAffineTransformMakeScale(0.89, 0.89)
        })
    }
    
    func animateButtonUp(button: UIButton) {
        UIView.animateWithDuration(0.10, animations: { () -> Void in
            button.transform = CGAffineTransformIdentity
        })
    }

}
