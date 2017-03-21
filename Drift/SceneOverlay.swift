//
//  SceneOverlay.swift
//  Drift
//
//  Created by Alex on 21/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

/**
 All overlay scenes will have a root node called Overlay
 We extract this Overlay root node and make it accessible for planting into other scenes
*/
class SceneOverlay {

    let overlayNode: SKSpriteNode

    init(overlayFileName: String) {
        let overlayScene = SKScene(fileNamed: overlayFileName)!
        let contentNode = overlayScene.childNode(withName: "Overlay") as! SKSpriteNode

        overlayNode = contentNode
        overlayNode.zPosition = .infinity
    }

    func attachOverlay(destination: SKScene) {
        overlayNode.removeFromParent()
        destination.camera?.addChild(overlayNode)

        // Resize the background node to the size of the scene's visible area
        overlayNode.size = destination.size
    }

    func removeOverlay() {
        overlayNode.removeFromParent()
    }

}
