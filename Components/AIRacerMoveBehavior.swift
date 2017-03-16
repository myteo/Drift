//
//  AIRacerMoveBehavior.swift
//  Drift
//
//  Created by Teo Ming Yi on 11/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class AIRacerMoveBehavior: GKBehavior {

    init(targetSpeed: Float, avoid: [GKAgent], permanentObstacles: [SKNode], waypoints: [CGPoint]) {
        super.init()

        let obstacles = SKNode.obstacles(fromNodeBounds: permanentObstacles)
        addMovementGoals(obstacles: obstacles, rawWaypoints: waypoints)
        addSpeedGoal(speed: targetSpeed)
        addAvoidAgentGoals(avoid: avoid)
    }

    private func addSpeedGoal(speed: Float) {
        setWeight(0.1, for: GKGoal(toReachTargetSpeed: speed))
    }

    private func addAvoidAgentGoals(avoid: [GKAgent]) {
        setWeight(GameplayConfiguration.AIRacer.avoidAgentWeight,
                for: GKGoal(toAvoid: avoid,
                        maxPredictionTime: GameplayConfiguration.AIRacer.avoidAgentPredictionTime))
        setWeight(GameplayConfiguration.AIRacer.avoidAgentWeight,
                for: GKGoal(toSeparateFrom: avoid,
                        maxDistance: GameplayConfiguration.AIRacer.separationDistance,
                        maxAngle: GameplayConfiguration.AIRacer.separationAngle))

    }

    private func addMovementGoals(obstacles: [GKPolygonObstacle], rawWaypoints: [CGPoint]) {
        let waypoints = rawWaypoints.map {float2($0)}
        let obstacleGraph = GKObstacleGraph(obstacles: obstacles,
                bufferRadius: GameplayConfiguration.AIRacer.obstacleBufferRadius)

        var pathNodes: [GKGraphNode] = []

        for index in 0..<waypoints.count {
            let startNode = GKGraphNode2D(point: waypoints[index])
            let endNode = GKGraphNode2D(point: waypoints[(index + 1) % waypoints.count])
            obstacleGraph.connectUsingObstacles(node: startNode)
            obstacleGraph.connectUsingObstacles(node: endNode)

            let obstaclePath = obstacleGraph.findPath(from: startNode, to: endNode)
            guard !obstaclePath.isEmpty else {
                fatalError("Unable to create path for ai")
            }
            pathNodes.append(contentsOf: obstaclePath)
            obstacleGraph.remove([startNode, endNode])
        }

        let path = GKPath(graphNodes: pathNodes,
                          radius: GameplayConfiguration.AIRacer.pathRadius)

        setWeight(GameplayConfiguration.AIRacer.followPathWeight,
                  for: GKGoal(toFollow: path,
                              maxPredictionTime: GameplayConfiguration.AIRacer.followPathPredictionTime,
                              forward: true))
        setWeight(GameplayConfiguration.AIRacer.stayOnPathWeight,
                  for: GKGoal(toStayOn: path,
                              maxPredictionTime: GameplayConfiguration.AIRacer.stayOnPathPredictionTime))
        setWeight(GameplayConfiguration.AIRacer.avoidObstaclesWeight,
                  for: GKGoal(toAvoid: obstacles,
                              maxPredictionTime: GameplayConfiguration.AIRacer.avoidObstaclesPredictionTime))
    }
}
