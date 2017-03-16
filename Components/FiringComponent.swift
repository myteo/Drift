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

        laserSpriteComponent.node.position.x += zRotation.getVector().dx * vehicle.size.height / 2
        laserSpriteComponent.node.position.y += zRotation.getVector().dy * vehicle.size.height / 2
        laserSpriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: laserSpriteComponent.node.size)
        laserSpriteComponent.node.physicsBody?.allowsRotation = false
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
}
