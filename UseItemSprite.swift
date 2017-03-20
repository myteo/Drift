//
//  UseItemSprite.swift
//  Drift
//
//  Created by Teo Ming Yi on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

class UseItemSprite: SKSpriteNode {

    func updateDisplay(_ powerUpType: PowerUpType) {
        texture = SKTexture(image: powerUpType.getImage())
    }

    func useItem() {
        texture = nil
    }
}
