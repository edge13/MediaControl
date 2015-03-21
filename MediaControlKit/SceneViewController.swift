//
//  SceneViewController.swift
//  MediaControl
//
//  Created by Joel Angelone on 3/14/15.
//  Copyright (c) 2015 Draken Design. All rights reserved.
//

import UIKit

public class SceneViewController: UIViewController, SceneViewDelegate {
    public var sceneController: SceneController?
    public var sceneViews: Array<SceneView>?
    public var scenes: Array<Scene>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Appearance.lightGrayColor
        
        sceneController = SceneController()
        
        scenes = sceneController?.loadScenes()
        sceneViews = Array<SceneView>()
        
        for device in scenes! {
            var deviceView = SceneView(scene: device)
            deviceView.delegate = self
            
            view.addSubview(deviceView)
            sceneViews!.append(deviceView)
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let sceneViews = sceneViews {
            let size = view.bounds.size
            let bounds = view.bounds
            
            let scenePadding = CGRectGetHeight(bounds) / 10.0
            let totalPadding = CGFloat(sceneViews.count + 1) * scenePadding
            
            let sceneBounds = CGRectMake(0, 0, CGRectGetWidth(bounds), (CGRectGetHeight(bounds) - totalPadding) / CGFloat(sceneViews.count))
            
            for (index, sceneView) in enumerate(sceneViews) {
                let origin = CGRectGetHeight(sceneBounds) * CGFloat(index)
                let padding = scenePadding * CGFloat(index + 1)
                
                sceneView.bounds = sceneBounds
                sceneView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(sceneBounds) + origin + padding)
            }
        }
    }
    
    public func sceneViewDidTapCommand(sceneView: SceneView, command: Command) {
        sceneController?.sendCommand(command)
    }
}
