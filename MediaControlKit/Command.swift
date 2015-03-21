//
//  Command.swift
//  MediaControlKit
//
//  Created by Joel Angelone on 2/15/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit

public enum CommandType: Int {
    case Power = 0
    case VolumeUp
    case VolumeDown
}

public class Command: NSObject {
    public var type: CommandType?
    public var message: String?
    public var hostName: String?
    public var port: Int?
}
