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

class MoveComponent: GKAgent2D, GKAgentDelegate {
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, mass: Float, node: SKNode) {
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = mass
        
        guard let gameScene = node.scene as? GameScene else {
            return
        }
        behavior = MoveBehavior(
                targetSpeed: maxSpeed,
                avoid: [],
                permanentObstacles: gameScene.aiMovementBoundaries,
                waypoints: gameScene.aiMovementWaypoints
        )
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
    }
    
}
