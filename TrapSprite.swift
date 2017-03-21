//
//  TrapSprite.swift
//  Drift
//
//  Created by Teo Ming Yi on 21/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

class TrapSprite: SKSpriteNode {

    func initTrap(at position: CGPoint) {
        guard let unwrappedTexture = texture else {
            return
        }
        self.position = position
        size = CGSize(width: 75.0, height: 75.0)
        zPosition = 120
        physicsBody = SKPhysicsBody(texture: unwrappedTexture,
                                    size: size)
        physicsBody?.categoryBitMask = ColliderType.PowerUp
        physicsBody?.contactTestBitMask = ColliderType.Vehicles
    }

    func removeSprite() {
        removeFromParent()
    }
}
