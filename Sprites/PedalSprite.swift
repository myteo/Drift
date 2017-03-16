//
//  PedalSprite.swift
//  Drift
//
//  Created by Leon on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

class PedalSprite: SKNode {
    var playerSprite = VehicleSprite()
    var spriteName = String()

    init(playerSprite: VehicleSprite, name: String) {
        let texture = SKTexture(imageNamed: name)
        self.playerSprite = playerSprite
        spriteName = name
        super.init()

        let pedal = SKSpriteNode(texture: texture, color: UIColor.black, size: texture.size())
        pedal.alpha = Sprites.alphaUnpressed
        isUserInteractionEnabled = true
        xScale = 1.5
        yScale = 1.5
        addChild(pedal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches()
    }

    func handleTouches() {
        switch spriteName {
        case Sprites.Names.accelerator: playerSprite.accelerate()
        case Sprites.Names.brake: playerSprite.decelerate()
        default: break
        }
        self.alpha = Sprites.alphaPressed
        playerSprite.physicsBody?.angularVelocity = 0
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerSprite.isAccelerating = false
        playerSprite.isDecelerating = false
        self.alpha = Sprites.alphaUnpressed
    }
}
