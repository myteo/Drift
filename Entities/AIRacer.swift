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
    let entityManager: EntityManager

    init(spriteNode: SKSpriteNode, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        let spriteComponent = SpriteComponent(entity: self,
                                              spriteNode: spriteNode)
        addComponent(spriteComponent)
        
        let moveComponent = MoveComponent.aiMoveComponent(node: spriteNode, entityManager: entityManager)
        addComponent(moveComponent)

        let firingComponent = FiringComponent(entityManager: entityManager)
        addComponent(firingComponent)
        
        let automaticFiringComponent = AutomaticFiringComponent(entityManager: entityManager)
        addComponent(automaticFiringComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
