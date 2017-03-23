//
//  PowerUpComponent.swift
//  Drift
//
//  Created by Teo Ming Yi on 18/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PowerUpComponent: GKComponent {

    private let entityManager: EntityManager
    private let powerUpType: PowerUpType

    init(entityManager: EntityManager, powerUpType: PowerUpType) {
        self.entityManager = entityManager
        self.powerUpType = powerUpType
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func activatePower() {
        switch powerUpType {
        case .speedBoost:
            activateSpeedBoost()
        case .trap:
            setTrap()
        case .immunity:
            gainImmunity()
        case .frostBullet:
            fireFrostBullet()
        case .homingMissile:
            fireHomingMissile()
        case .globalDownSize:
            activateGlobalDownsize()
        }
    }

    func activateSpeedBoost() {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let vehicleSprite = spriteComponent.node as? VehicleSprite,
            let gameScene = vehicleSprite.scene as? GameScene else {
                return
        }
        guard !vehicleSprite.isNerfed else {
            return
        }
        vehicleSprite.boostSpeed()
        if entity is PlayerRacer {
            gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "speedBoost"))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() +
            GameplayConfiguration.PowerUps.powerUpDuration, execute: {
                vehicleSprite.reduceSpeedToNormal()
                if vehicleSprite.entity is PlayerRacer {
                    gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "blank"))
                }
        })
    }

    func setTrap() {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let vehicleSprite = spriteComponent.node as? VehicleSprite else {
                return
        }
        vehicleSprite.setTrap()
    }

    func gainImmunity() {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let vehicleSprite = spriteComponent.node as? VehicleSprite,
            let gameScene = vehicleSprite.scene as? GameScene else {
                return
        }
        guard !vehicleSprite.isNerfed else {
            return
        }
        vehicleSprite.gainImmunity()
        if entity is PlayerRacer {
            gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "immunity"))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() +
            GameplayConfiguration.PowerUps.powerUpDuration, execute: {
                vehicleSprite.loseImmunity()
                gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "blank"))
        })
    }

    func fireFrostBullet() {
        guard let firingComponent = entity?.component(ofType: FiringComponent.self) else {
            return
        }
        firingComponent.fireStraightBullet()
    }

    func fireHomingMissile() {
        guard let firingComponent = entity?.component(ofType: FiringComponent.self) else {
            return
        }
        firingComponent.fireSmartMissile()
    }

    func activateGlobalDownsize() {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let vehicleSprite = spriteComponent.node as? VehicleSprite,
            let gameScene = vehicleSprite.scene as? GameScene else {
                return
        }
        let racerEntities = entityManager.getAllRacerEntities()
        for racer in racerEntities {
            guard racer !== entity else {
             continue
             }
            guard let spriteComponent = racer.component(ofType: SpriteComponent.self),
                let vehicleSprite = spriteComponent.node as? VehicleSprite else {
                    continue
            }
            guard vehicleSprite.downSize() else {
                continue
            }
            if racer is PlayerRacer {
                gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "globalDownsize"))
            } else {
                guard let moveComponent = racer.component(ofType: MoveComponent.self) else {
                    continue
                }
                moveComponent.maxSpeed /= 200
                moveComponent.maxAcceleration /= 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() +
                GameplayConfiguration.PowerUps.powerUpDuration, execute: {
                    vehicleSprite.endDownSize()
                    if racer is PlayerRacer && vehicleSprite.isBuffed {
                        gameScene.playerStatusSprite.texture = SKTexture(image: #imageLiteral(resourceName: "blank"))
                    } else {
                        if let moveComponent = racer.component(ofType: MoveComponent.self) {
                            moveComponent.maxSpeed *= 200
                            moveComponent.maxAcceleration *= 2
                        }
                    }
            })
        }
    }

    func getPowerUpType() -> PowerUpType {
        return powerUpType
    }
}
