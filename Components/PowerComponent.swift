//
//  PowerComponent.swift
//  Drift
//
//  Created by Teo Ming Yi on 18/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PowerComponent: GKComponent {

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

    func activatePower(racerSprite: SpriteComponent) {
        guard let vehicle = racerSprite.node as? VehicleSprite,
            !vehicle.isPoweredUp else {
                return
        }
        switch powerUpType {
        case .speedBoost:
            vehicle.boostSpeed()
        case .speedReduction:
            vehicle.reduceSpeed()
        }
    }
}
