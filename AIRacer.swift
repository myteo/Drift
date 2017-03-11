//
//  AIRacer.swift
//  Drift
//
//  Created by Teo Ming Yi on 11/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class AIRacer: GKEntity {

    init(spriteNode: SKSpriteNode) {

        super.init()
        let spriteComponent = SpriteComponent(entity: self,
                                              spriteNode: spriteNode)
        addComponent(spriteComponent)
        let moveComponent = MoveComponent(maxSpeed: 300,
                                          maxAcceleration: 170,
                                          radius: Float(spriteNode.size.width / 2),
                                          mass: 0.7,
                                          node: spriteNode)
        addComponent(moveComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
