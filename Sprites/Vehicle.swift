//
//  Vehicle.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

class Vehicle: SKSpriteNode {
    
    var direction = Direction.NW
    var isMoving = true
    var imagePrefix = Sprites.CarColors.Black

    func initVehicle(name: String) {
        imagePrefix = name
        texture = getTexture(prefix: name, direction: direction)
        
        physicsBody = SKPhysicsBody(polygonFrom: direction.path)
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = ColliderType.Vehicles
        physicsBody?.collisionBitMask = ColliderType.Vehicles | ColliderType.Obstacles
    }
    
    func turnAntiClockwise() {
        direction.turnAntiClockwise()
        texture = getTexture(prefix: imagePrefix, direction: direction)
        size = texture!.size()
        physicsBody = SKPhysicsBody(polygonFrom: direction.path)
    }
    
    func turnClockwise() {
        direction.turnClockwise()
        texture = getTexture(prefix: imagePrefix, direction: direction)
        size = texture!.size()
        physicsBody = SKPhysicsBody(polygonFrom: direction.path)
    }

    
    func getTexture(prefix: String, direction: Direction) -> SKTexture {
        return SKTexture(imageNamed: "\(prefix)\(direction.name)")
    }
}
