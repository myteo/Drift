//
//  PowerUp.swift
//  Drift
//
//  Created by Teo Ming Yi on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class PowerUp: GKEntity, ContactNotifiableType {

    init(powerUpType: PowerUpType, spriteNode: SKSpriteNode, entityManager: EntityManager) {

        super.init()

        let spriteComponent = SpriteComponent(entity: self,
                                              spriteNode: spriteNode)
        addComponent(spriteComponent)

        let powerComponent = PowerComponent(entityManager: entityManager,
                                            powerUpType: powerUpType)
        addComponent(powerComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func contactWithEntityDidBegin(_ entity: GKEntity) {
        guard let racerSprite = entity.component(ofType: SpriteComponent.self) else {
            return
        }
        guard let spriteComponent = self.component(ofType: SpriteComponent.self),
            let powerComponent = self.component(ofType: PowerComponent.self) else {
                return
        }
        powerComponent.activatePower(racerSprite: racerSprite)
        spriteComponent.removeAndRespawn()

    }
}
