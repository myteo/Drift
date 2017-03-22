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
    func fireStraightBullet() {
        let laser = Laser(entityManager: entityManager)

        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let laserSpriteComponent = laser.component(ofType: SpriteComponent.self),
            let vehicle = spriteComponent.node as? VehicleSprite else {
            return
        }
        let zRotation = vehicle.zRotation
        laserSpriteComponent.node.position = vehicle.position

        laserSpriteComponent.node.position.x += zRotation.getVector().dx * vehicle.size.height * 0.8
        laserSpriteComponent.node.position.y += zRotation.getVector().dy * vehicle.size.height * 0.8
        let laserPointsPerSecond = CGFloat(500)
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

    func fireSmartMissile() {
        guard let hostMoveComponent = entity?.component(ofType: MoveComponent.self),
            let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let vehicle = spriteComponent.node as? VehicleSprite else {
            return
        }

        let missile = SmartMissile(position: vehicle.position, entityManager: entityManager, nonTargets: [hostMoveComponent])

        guard let missileSpriteComponent = missile.component(ofType: SpriteComponent.self) else {
            return
        }

        // shift the missile to the head of the vehicle
        let zRotation = vehicle.zRotation
        missileSpriteComponent.node.position = vehicle.position
        let normalVector = (zRotation + CGFloat.π/2).getVector()
        missileSpriteComponent.node.position.x += normalVector.dx * vehicle.size.width
        missileSpriteComponent.node.position.y += normalVector.dy * vehicle.size.width
        missileSpriteComponent.node.zRotation = zRotation
        missileSpriteComponent.node.zPosition = 1

        // TODO: add physics body after powerup collection is added & make missile disappear properly
        missileSpriteComponent.node.run(SKAction.sequence([
            SKAction.wait(forDuration: TimeInterval(10)),
            SKAction.run { self.entityManager.remove(missile) }
            ])
        )

        entityManager.add(missile)

    }
}
