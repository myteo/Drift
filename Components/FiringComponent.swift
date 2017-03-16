//
//  FiringComponent.swift
//  Drift
//
//  Created by Leon on 13/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FiringComponent: GKComponent {
    let entityManager: EntityManager

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Fires linear laser based on 
    func fireVehicleLaser() {
        let laser = Laser(entityManager: entityManager)

        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let laserSpriteComponent = laser.component(ofType: SpriteComponent.self),
            let vehicle = spriteComponent.node as? VehicleSprite else {
            return
        }

        laserSpriteComponent.node.position = vehicle.position
        let zRotation = vehicle.zRotation
        let laserPointsPerSecond = CGFloat(300)
        let laserDistance = CGFloat(1000)

        let target = zRotation.getVector() * laserDistance
        let duration = laserDistance / laserPointsPerSecond

        laserSpriteComponent.node.zRotation = zRotation
        laserSpriteComponent.node.zPosition = 1

        laserSpriteComponent.node.run(SKAction.sequence([
            SKAction.moveBy(x: target.dx, y: target.dy, duration: TimeInterval(duration)),
            SKAction.run { self.entityManager.remove(laser) }
            ])
        )

        entityManager.add(laser)

    }
}
