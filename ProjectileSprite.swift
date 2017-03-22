//
//  ProjectileSprite.swift
//  Drift
//
//  Created by Teo Ming Yi on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

class ProjectileSprite: SKSpriteNode {

    func initProjectile() {
        guard let unwrappedTexture = texture else {
            return
        }
        zPosition = 120
        physicsBody = SKPhysicsBody(texture: unwrappedTexture,
                                    size: size)
        physicsBody?.categoryBitMask = ColliderType.PowerUp
        physicsBody?.contactTestBitMask = ColliderType.Vehicles
        physicsBody?.allowsRotation = false
    }

    func removeSprite() {
        removeFromParent()
    }
}
