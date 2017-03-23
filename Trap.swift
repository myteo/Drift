//
//  Trap.swift
//  Drift
//
//  Created by Teo Ming Yi on 21/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Trap: GKEntity, ContactNotifiableType {

    let entityManager: EntityManager

    init(spriteNode: SKSpriteNode, entityManager: EntityManager) {

        self.entityManager = entityManager

        super.init()

        let spriteComponent = SpriteComponent(entity: self,
                                              spriteNode: spriteNode)
        addComponent(spriteComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ContactNotifiableType
    func contactWithEntityDidBegin(_ entity: GKEntity, at scene: SKScene) {
        guard let spriteComponent = self.component(ofType: SpriteComponent.self)?.node as? TrapSprite else {
            return
        }
        spriteComponent.removeFromParent()
        if let playerRacer = entity as? PlayerRacer {
            handleCollisionWithPlayer(playerRacer: playerRacer)
        } else if let AIRacer = entity as? AIRacer {
            handleCollisionWithAI(AIRacer: AIRacer)
        }
    }

    func handleCollisionWithPlayer(playerRacer: PlayerRacer) {
        guard let vehicleSprite = playerRacer.component(ofType: SpriteComponent.self)?.node as? VehicleSprite,
            let gameScene = vehicleSprite.scene as? GameScene else {
                return
        }
        guard vehicleSprite.immobilize() else {
            return
        }
        gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "trap"))
        DispatchQueue.main.asyncAfter(deadline: .now() +
            GameplayConfiguration.PowerUps.powerUpDuration, execute: {
                vehicleSprite.endImmobility()
                gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "blank"))
                self.entityManager.remove(self)
        })
    }

    func handleCollisionWithAI(AIRacer: AIRacer) {
        guard let moveComponent = AIRacer.component(ofType: MoveComponent.self) else {
            return
        }
        moveComponent.maxSpeed = 0.01
        DispatchQueue.main.asyncAfter(deadline: .now() +
            GameplayConfiguration.PowerUps.powerUpDuration, execute: {
                moveComponent.maxSpeed = moveComponent.type.maxSpeed
        })
    }
}
