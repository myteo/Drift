//
// Created by Alex on 18/3/17.
// Copyright (c) 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class AutomaticFiringComponent: GKComponent {
    let entityManager: EntityManager
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let firingComponent = entity?.component(ofType: FiringComponent.self) else {
            return
        }

        if visibleVehicleAhead(distance: firingComponent.straightBulletRange / 2) != nil {
            firingComponent.fireStraightBullet()
        }
    }
    
    func visibleVehicleAhead(distance: CGFloat) -> GKEntity? {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return nil
        }
        

        let zRotation = spriteComponent.node.zRotation
        let rayStart = spriteComponent.node.position
        
        let angle = spriteComponent.node.zRotation - CGFloat.π_2
        let rayEnd = CGPoint(x: distance * cos(angle),
                y: distance * sin(angle))

        let body = entityManager.scene.physicsWorld.body(alongRayStart: rayStart, end: rayEnd)
        
        let x = body?.node?.alpha
        if x != nil {
            body?.node?.alpha = -x!
        }
        
        if body?.categoryBitMask == ColliderType.Vehicles {
            return body?.node?.entity
        } else {
            return nil
        }
    }
}
