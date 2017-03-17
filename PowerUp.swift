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

    let powerUpType: PowerUpType

    private let entityManager: EntityManager

    init(powerUpType: PowerUpType, spriteNode: SKSpriteNode, entityManager: EntityManager) {

        self.entityManager = entityManager
        self.powerUpType = powerUpType

        super.init()
        let spriteComponent = SpriteComponent(entity: self,
                                              spriteNode: spriteNode)
        addComponent(spriteComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func contactWithEntityDidBegin(_ entity: GKEntity) {
        guard let racerSprite = entity.component(ofType: SpriteComponent.self),
            let vehicleSprite = racerSprite.node as? VehicleSprite else {
                return
        }
        switch powerUpType {
        case .speedBoost:
            vehicleSprite.boostSpeed()
        case .speedReduction:
            vehicleSprite.reduceSpeed()
        }
        // Remove power up
        guard let spriteComponent = self.component(ofType: SpriteComponent.self) else {
            return
        }
        spriteComponent.node.removeFromParent()
        entityManager.remove(self)
    }
}
