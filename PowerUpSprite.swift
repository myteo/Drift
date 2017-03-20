//
//  PowerUpSprite.swift
//  Drift
//
//  Created by Teo Ming Yi on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

class PowerUpSprite: SKSpriteNode {

    var originalPosition = CGPoint()

    func initPowerUp() {
        guard let unWrappedtexture = texture else {
            return
        }
        physicsBody = SKPhysicsBody(texture: unWrappedtexture,
                                    size: unWrappedtexture.size())
        physicsBody?.categoryBitMask = ColliderType.PowerUp
        physicsBody?.contactTestBitMask = ColliderType.Vehicles
        originalPosition = position
    }

    func removeAndRespawn() {
        let parentNode = parent
        removeFromParent()
        position = originalPosition
        DispatchQueue.main.asyncAfter(deadline: .now() +
            5.0, execute: {
                parentNode?.addChild(self)
        })
    }
}
