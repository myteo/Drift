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

        let powerComponent = PowerUpComponent(entityManager: entityManager,
                                            powerUpType: powerUpType)
        addComponent(powerComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Called when `PowerUp` comes into contact with `PlayerRacer` or `AIRacer`
    func contactWithEntityDidBegin(_ entity: GKEntity) {
        assert(entity is AIRacer || entity is PlayerRacer)

        guard let spriteComponent = self.component(ofType: SpriteComponent.self),
            let powerComponent = self.component(ofType: PowerUpComponent.self) else {
                return
        }
        /// Add powerComponent to entity if it does not already have a PowerUpComponent
        if entity.component(ofType: PowerUpComponent.self) == nil {
            entity.addComponent(powerComponent)
        }
        spriteComponent.removeAndRespawn()
    }
}
