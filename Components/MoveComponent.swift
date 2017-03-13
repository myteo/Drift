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
    
    private let entityManager: EntityManager
    private let type: AgentMoveType
    private var previousPoint: CGPoint
    
    init(type: AgentMoveType, node: SKSpriteNode, entityManager: EntityManager) {
        self.entityManager = entityManager
        self.type = type
        self.previousPoint = node.position
        super.init()
        delegate = self
        self.maxSpeed = type.maxSpeed
        self.maxAcceleration = type.maxAcceleration
        self.mass = type.mass
        self.radius = Float(node.size.width / 2)
        
        guard let gameScene = node.scene as? GameScene else {
            return
        }
        
        switch type {
        case .AIRacer:
            behavior = AIRacerMoveBehavior(
                targetSpeed: maxSpeed,
                avoid: entityManager.getAllVehicleAgents(),
                permanentObstacles: gameScene.aiMovementBoundaries,
                waypoints: gameScene.aiMovementWaypoints
            )
            
        case .PlayerRacer:
            //nothing to do
            behavior = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        if type == .PlayerRacer {
            return
        }
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        position = float2(spriteComponent.node.position)
        previousPoint = spriteComponent.node.position
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        if type == .PlayerRacer {
            return
        }
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        let nextPosition = CGPoint(position)
        let newDirection = Direction.getNextDirection(previousPoint, nextPosition)
        spriteComponent.node.position = nextPosition
        if let vehicle = spriteComponent.node as? Vehicle {
            let texture = vehicle.getTexture(prefix: vehicle.imagePrefix, direction: newDirection)
            vehicle.texture = texture
            vehicle.size = texture.size()
            vehicle.resetPhysicsBody(direction: newDirection)
        }
        previousPoint = nextPosition
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        switch type {
        case .PlayerRacer:
            // update agent's speed & rotation, might be required for behaviors of other agents
            if let velocity = spriteComponent.node.physicsBody?.velocity {
                self.speed = Float(velocity.magnitude)
                self.rotation = atan2(Float(velocity.dy), Float(velocity.dx))
            }
        default:
            break
            // nothing to do 
        }
    }
    
}
