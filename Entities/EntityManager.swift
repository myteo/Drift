//  EntityManager.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene

    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        return [moveSystem]
    }()

    init(scene: SKScene) {
        self.scene = scene
    }

    func add(_ entity: GKEntity) {
        entities.insert(entity)
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }

        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node,
            spriteNode.parent == nil {
            scene.addChild(spriteNode)
        }
    }

    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        toRemove.insert(entity)
        entities.remove(entity)
    }

    func getAllVehicleAgents() -> [GKAgent2D] {
        var agents: [GKAgent2D] = []
        for entity in entities {
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                switch moveComponent.type {
                case .AIRacer, .PlayerRacer:
                    agents.append(moveComponent)
                default:
                    break
                }
            }
        }
        return agents
    }

    func getAllRacerEntities() -> [GKEntity] {
        var racerEntities: [GKEntity] = []
        for entity in entities {
            guard entity is PlayerRacer || entity is AIRacer else {
                continue
            }
            racerEntities.append(entity)
        }
        return racerEntities
    }

    func closestVehicleAgent(point: CGPoint, excluding: [GKAgent2D]) -> GKAgent2D? {
        return getAllVehicleAgents()
            .filter { agent in
                return !excluding.contains(agent)
            }
            .reduce(nil) { result, agent in
                guard let result = result else {
                    return agent
                }

                let toResult = point.distance(to: CGPoint(vectorFloat2: result.position))
                let toNew = point.distance(to: CGPoint(vectorFloat2: agent.position))
                return toResult < toNew
                    ? result
                    : agent
        }
    }

    func update(deltaTime: TimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }

        for remove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: remove)
            }
        }
        toRemove.removeAll()
    }
}
