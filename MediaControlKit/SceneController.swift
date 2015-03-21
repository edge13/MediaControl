//
//  SceneController.swift
//  MediaControlKit
//
//  Created by Joel Angelone on 2/27/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit

public class SceneController: NSObject {
    var hosts: Dictionary<String, Host>
    var scenes: Array<Scene>?
    
    public override init() {
        hosts = Dictionary<String, Host>()
    }
    
    public func loadScenes() -> Array<Scene> {
        if scenes == nil {
            scenes = Array<Scene>()
            
            if let path = NSBundle.mainBundle().pathForResource("Scenes", ofType: "plist") {
                let sceneData = NSArray(contentsOfFile: path) as? [NSDictionary]
                
                if let sceneData = sceneData {
                    for sceneDictionary in sceneData {
                        let scene = Scene()
                        scene.dispayName = sceneDictionary["DisplayName"] as? String
                        scene.commands = Array<Command>()
                        
                        if let commandData = sceneDictionary["Commands"] as? [NSDictionary] {
                            for commandDictionary in commandData {
                                let command = Command()
                                if let type = commandDictionary["Type"]?.integerValue {
                                    command.type = CommandType(rawValue: type)
                                }
                                
                                command.hostName = commandDictionary["HostName"] as? String
                                command.port = commandDictionary["Port"]?.integerValue
                                
                                if let message = commandDictionary["Message"] as? String {
                                    command.message = self.trimMessage(message)
                                }
                                
                                scene.commands?.append(command)
                            }
                        }
                        
                        scenes?.append(scene)
                    }
                }
            }
        }
        
        return scenes!
    }
    
    public func sendCommand(command: Command) {
        let host = hostForCommand(command)
        host.sendMessage(command.message!)
    }
    
    public func disconnectHosts() {
        for (hostKey, host) in hosts {
            host.disconnect()
        }
    }
    
    func hostForCommand(command: Command) -> Host {
        let hostKey = "\(command.hostName!):\(command.port!)"
        var host = hosts[hostKey]
        if host == nil {
            host = Host(hostName: command.hostName!, port: command.port!)
            hosts[hostKey] = host
        }
        return host!
    }
    
    func trimMessage(message: String) -> String {
        return message.stringByReplacingOccurrencesOfString("\\r", withString: "\r", options: .LiteralSearch, range: nil)
    }
}
