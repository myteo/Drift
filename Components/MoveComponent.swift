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

    let type: AgentMoveType
    private let entityManager: EntityManager
    private var previousPoint: CGPoint

    private init(type: AgentMoveType, node: SKSpriteNode, entityManager: EntityManager) {
        self.entityManager = entityManager
        self.type = type
        self.previousPoint = node.position
        super.init()
        delegate = self
        self.maxSpeed = type.maxSpeed
        self.maxAcceleration = type.maxAcceleration
        self.mass = type.mass
        self.radius = Float(node.size.width / 2)
        updateAgentPositionUsingSprite()
    }

    static func playerMoveComponent(node: SKSpriteNode, entityManager: EntityManager) -> MoveComponent {
        // is a static agent, does not need any behavior
        let moveComponent = MoveComponent(type: .PlayerRacer, node: node, entityManager: entityManager)
        return moveComponent
    }

    static func aiMoveComponent(node: SKSpriteNode, entityManager: EntityManager) -> MoveComponent {
        let moveComponent = MoveComponent(type: .AIRacer, node: node, entityManager: entityManager)

        guard let gameScene = node.scene as? GameScene else {
            fatalError("Node does not belong to a gamescene. Should not happen")
        }

        /*
        moveComponent.behavior = AIRacerMoveBehavior(
            targetSpeed: moveComponent.maxSpeed,
            avoid: entityManager.getAllVehicleAgents(),
            permanentObstacles: gameScene.aiMovementBoundaries,
            waypoints: gameScene.aiMovementWaypoints
        )
 */

        return moveComponent
    }

    static func smartMissileMoveComponent(node: SKSpriteNode, entityManager: EntityManager, agentsToExclude: [GKAgent2D]) -> MoveComponent {

        let moveComponent = MoveComponent(type: .SmartMissile, node: node, entityManager: entityManager)
        guard let closest = entityManager.closestVehicleAgent(point: node.position, excluding: agentsToExclude) else {
            fatalError("No agent to fire at, should not happen!")
        }
        moveComponent.behavior = AIProjectileMoveBehavior(
            targetSpeed: moveComponent.maxSpeed,
            seek: closest,
            obstaclesToAvoid: []
        )

        return moveComponent
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func agentWillUpdate(_ agent: GKAgent) {
        if type == .PlayerRacer {
            return
        }
        updateAgentPositionUsingSprite()
    }
    
    private func updateAgentPositionUsingSprite() {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        position = float2(spriteComponent.node.position)
        previousPoint = spriteComponent.node.position
        rotation = Float(spriteComponent.node.zRotation.adding(CGFloat.π_2))
        
    }

    func agentDidUpdate(_ agent: GKAgent) {
        if type == .PlayerRacer {
            return
        }
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        let nextPoint = CGPoint(position)
        let angle = CGFloat(atan2(nextPoint.y - previousPoint.y, nextPoint.x - previousPoint.x))
        spriteComponent.node.zRotation = angle - CGFloat.π_2
        spriteComponent.node.position = nextPoint
        previousPoint = nextPoint
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }

        switch type {
        case .PlayerRacer:
            // update agent's speed & rotation, might be required for behaviors of other agents
            // this behavior is required for PlayerRacer, as it has a static agent
            if let velocity = spriteComponent.node.physicsBody?.velocity {
                self.speed = Float(velocity.magnitude)
                self.rotation = atan2(Float(velocity.dy), Float(velocity.dx))
            }
        default:
            break
        }
    }

}
