//
//  MoveComponent.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// TODO: rename to something better?
class MoveComponent: GKAgent2D, GKAgentDelegate {
    
    private let entityManager: EntityManager
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, mass: Float,
         node: SKNode, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = mass
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        position = float2(spriteComponent.node.position)
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(position)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
            let gameScene = spriteComponent.node.scene as? GameScene else {
            return
        }
        
        behavior = MoveBehavior(
                targetSpeed: maxSpeed,
                avoid: entityManager.getAllVehicleAgents(),
                permanentObstacles: gameScene.aiMovementBoundaries,
                waypoints: gameScene.aiMovementWaypoints
        )
    }
    
}
