//
//  SmartMissile.swift
//  Drift
//
//  Created by Alex on 16/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class SmartMissile: GKEntity {

    init(position: CGPoint, entityManager: EntityManager, nonTargets: [GKAgent2D]) {
        super.init()

        let texture = SKTexture(imageNamed: Projectiles.SmartMissile.Name)
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        spriteComponent.node.position = position
        addComponent(spriteComponent)

        let moveComponent = MoveComponent.smartMissileMoveComponent(node: spriteComponent.node, entityManager: entityManager, agentsToExclude: nonTargets)

        addComponent(moveComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
