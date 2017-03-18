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
    let straightBulletRange = CGFloat(1000)
    private(set) var straightBulletInCooldown = false
    let straightBulletCooldownDuration: TimeInterval = 0.3

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Fires linear laser based on 
    func fireStraightBullet() {
        guard !straightBulletInCooldown else {
            return
        }
        
        let laser = Laser(entityManager: entityManager)

        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let laserSpriteComponent = laser.component(ofType: SpriteComponent.self),
            let vehicle = spriteComponent.node as? VehicleSprite else {
            return
        }

        let zRotation = vehicle.zRotation
        laserSpriteComponent.node.position = vehicle.position

        laserSpriteComponent.node.position.x += zRotation.getVector().dx * vehicle.size.height / 2
        laserSpriteComponent.node.position.y += zRotation.getVector().dy * vehicle.size.height / 2
        laserSpriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: laserSpriteComponent.node.size)
        laserSpriteComponent.node.physicsBody?.allowsRotation = false
        let laserPointsPerSecond = CGFloat(500)

        let target = zRotation.getVector() * straightBulletRange
        let duration = straightBulletRange / laserPointsPerSecond

        laserSpriteComponent.node.zRotation = zRotation
        laserSpriteComponent.node.zPosition = 1

        laserSpriteComponent.node.run(SKAction.sequence([
            SKAction.moveBy(x: target.dx, y: target.dy, duration: TimeInterval(duration)),
            SKAction.run { self.entityManager.remove(laser) }
            ])
        )

        entityManager.add(laser)
        
        straightBulletInCooldown = true
        let when = DispatchTime.now() + straightBulletCooldownDuration
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.straightBulletInCooldown = false
        }

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
        missileSpriteComponent.node.position.x += zRotation.getVector().dx * vehicle.size.height / 2
        missileSpriteComponent.node.position.y += zRotation.getVector().dy * vehicle.size.height / 2
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
