//
//  MoveBehavior.swift
//  Drift
//
//  Created by Teo Ming Yi on 11/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class MoveBehavior: GKBehavior {
    
    init(targetSpeed: Float, avoid: [GKAgent], permanentObstacles: [SKNode], waypoints: [CGPoint]) {
        super.init()
        setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
        setWeight(1.0, for: GKGoal(toAvoid: avoid, maxPredictionTime: 1.0))
        
        let obstacles = SKNode.obstacles(fromNodeBounds: permanentObstacles)
        addMovementPath(obstacles: obstacles, rawWaypoints: waypoints)
    }

    private func addMovementPath(obstacles: [GKPolygonObstacle], rawWaypoints: [CGPoint]) {
        // TODO: change buffer radius into a constant in constants file
        let obstacleGraph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 10)
        var waypoints = rawWaypoints.map {float2($0)}
        
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
        
        // TODO: shift radius, max prediction time & other constants to constants file
        let path = GKPath(graphNodes: pathNodes, radius: 5)
        setWeight(1.0, for: GKGoal(toFollow: path, maxPredictionTime: 1, forward: true))
        setWeight(1.0, for: GKGoal(toStayOn: path, maxPredictionTime: 1))
        setWeight(1, for: GKGoal(toAvoid: obstacles, maxPredictionTime: 1))
    }
}

