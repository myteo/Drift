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
            let vehicleSprite = spriteComponent.node as? VehicleSprite else {
                return
        }
        vehicleSprite.boostSpeed()
        DispatchQueue.main.asyncAfter(deadline: .now() +
            GameplayConfiguration.SpeedBoost.speedBoostDuration, execute: {
                vehicleSprite.reduceSpeedToNormal()
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
            let vehicleSprite = spriteComponent.node as? VehicleSprite else {
                return
        }
        vehicleSprite.gainImmunity()
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

    }

    func getPowerUpType() -> PowerUpType {
        return powerUpType
    }
}
