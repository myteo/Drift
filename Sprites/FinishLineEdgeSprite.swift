//
//  FinishLineSprite.swift
//  Drift
//
//  Created by Alex on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

class FinishLineEdgeSprite: SKSpriteNode {

    func initFinishLineEdgeSprite(isStartEdge: Bool) {
        setPhysicsBody(isStartEdge: isStartEdge)
    }

    private func setPhysicsBody(isStartEdge: Bool) {
        // reset the position later, so that physics body follows the rotation
        let previousRotation = zRotation
        zRotation = 0
        let physicsBody = SKPhysicsBody(rectangleOf: frame.size)

        if isStartEdge {
            physicsBody.categoryBitMask = ColliderType.FinishLineStart
        } else {
            physicsBody.categoryBitMask = ColliderType.FinishLineEnd
        }

        physicsBody.collisionBitMask = 0
        physicsBody.contactTestBitMask = ColliderType.LapTracker

        self.physicsBody = physicsBody
        zRotation = previousRotation
    }
}
