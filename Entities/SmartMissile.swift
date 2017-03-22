//
//  SmartMissile.swift
//  Drift
//
//  Created by Alex on 16/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class SmartMissile: GKEntity, ContactNotifiableType {

    let entityManager: EntityManager

    init(position: CGPoint, entityManager: EntityManager, nonTargets: [GKAgent2D]) {
        self.entityManager = entityManager
        super.init()

        let texture = SKTexture(image: #imageLiteral(resourceName: "missile"))
        let spriteNode = ProjectileSprite(texture: texture)
        spriteNode.initProjectile()
        let spriteComponent = SpriteComponent(entity: self, spriteNode: spriteNode)
        addComponent(spriteComponent)

        let moveComponent = MoveComponent.smartMissileMoveComponent(node: spriteComponent.node, entityManager: entityManager, agentsToExclude: nonTargets)
        addComponent(moveComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ContactNotifiableType
    func contactWithEntityDidBegin(_ entity: GKEntity, at scene: SKScene) {
        entityManager.remove(self)
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
        gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "homingMissile"))
        DispatchQueue.main.asyncAfter(deadline: .now() +
            GameplayConfiguration.PowerUps.powerUpDuration, execute: {
                vehicleSprite.isImmobilized = false
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
