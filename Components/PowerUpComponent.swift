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
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
        let vehicleSprite = spriteComponent.node as? VehicleSprite else {
            return
        }
        switch powerUpType {
        case .speedBoost:
            vehicleSprite.boostSpeed()
        case .speedReduction:
            vehicleSprite.reduceSpeed()
        }
    }
}
