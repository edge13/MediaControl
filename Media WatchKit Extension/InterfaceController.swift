//
//  InterfaceController.swift
//  Media WatchKit Extension
//
//  Created by Joel Angelone on 3/20/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import WatchKit
import Foundation
import MediaControlKit

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var topSceneLabel: WKInterfaceLabel!
    @IBOutlet weak var bottomSceneLabel: WKInterfaceLabel!
    
    var sceneController: SceneController?
    var scenes: Array<Scene>?
    
    var topScene: Scene?
    var bottomScene: Scene?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        sceneController = SceneController()
        scenes = sceneController?.loadScenes()
        
        topScene = configureSceneAtIndex(0, label: topSceneLabel)
        bottomScene = configureSceneAtIndex(1, label: bottomSceneLabel)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
        sceneController?.disconnectHosts()
    }
    
    private func configureSceneAtIndex(index: Int, label: WKInterfaceLabel) -> Scene? {
        if scenes?.count > index {
            let scene = scenes?[index]
            label.setText(scene?.dispayName)
            return scene
        }
        return nil
    }
    
    private func sendCommand(commandType: CommandType, scene: Scene?) {
        if let commands = scene?.commands {
            for command in commands {
                if command.type == commandType {
                    sceneController?.sendCommand(command)
                    return
                }
            }
        }
    }
    
    @IBAction func topSceneVolumeDown() {
        sendCommand(.VolumeDown, scene: topScene)
    }
    
    @IBAction func topScenePower() {
        sendCommand(.Power, scene: topScene)
    }
    
    @IBAction func topSceneVolumeUp() {
        sendCommand(.VolumeUp, scene: topScene)
    }
    
    @IBAction func bottomSceneVolumeDown() {
        sendCommand(.VolumeDown, scene: bottomScene)
    }
    
    @IBAction func bottomScenePower() {
        sendCommand(.Power, scene: bottomScene)
    }
    
    @IBAction func bottomSceneVolumeUp() {
        sendCommand(.VolumeUp, scene: bottomScene)
    }
}
