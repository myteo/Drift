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

    init(powerUpSprite: PowerUpSprite, entityManager: EntityManager) {

        super.init()

        powerUpSprite.initPowerUp()
        let spriteComponent = SpriteComponent(entity: self,
                                              spriteNode: powerUpSprite)
        addComponent(spriteComponent)

        let powerUpType = PowerUpType.getRandomType()
        let powerUpComponent = PowerUpComponent(entityManager: entityManager,
                                                powerUpType: powerUpType)
        addComponent(powerUpComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Called when `PowerUp` comes into contact with `PlayerRacer` or `AIRacer`
    func contactWithEntityDidBegin(_ entity: GKEntity, at scene: SKScene) {
        assert(entity is AIRacer || entity is PlayerRacer)

        guard let spriteComponent = self.component(ofType: SpriteComponent.self)?.node as? PowerUpSprite,
            let powerUpComponent = self.component(ofType: PowerUpComponent.self) else {
                return
        }
        /// Add powerComponent to entity if it does not already have a PowerUpComponent
        if entity.component(ofType: PowerUpComponent.self) == nil {
            entity.addComponent(powerUpComponent)
            updateUseItemSprite(racerEntity: entity,
                                powerUpComponent: powerUpComponent,
                                scene: scene)
        }
        spriteComponent.removeAndRespawn()
    }

    private func updateUseItemSprite(racerEntity: GKEntity,
                                     powerUpComponent: PowerUpComponent,
                                     scene: SKScene) {
        guard let gameScene = scene as? GameScene,
            racerEntity is PlayerRacer else {
                return
        }
        let powerUpType = powerUpComponent.getPowerUpType()
        gameScene.useItemSprite.updateDisplay(powerUpType)
    }
}
