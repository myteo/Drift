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
    var imagePrefix = Sprites.Car.Colors.Black
    var isAccelerating = false
    var isDecelerating = false

    let maxSpeed = GameplayConfiguration.VehiclePhysics.maxSpeed
    let neutralPoint = CGFloat(70)
    var reversePoint = CGFloat(1)

    func initVehicle(name: String) {
        imagePrefix = name
        texture = getTexture(prefix: name, direction: direction)

        resetPhysicsBody(direction: direction)
    }

    func resetPhysicsBody(direction: Direction) {
        var previousVelocity = CGVector()
        if let v = physicsBody?.velocity {
            previousVelocity = v
        }
        physicsBody = SKPhysicsBody(polygonFrom: direction.path)
        physicsBody?.velocity = previousVelocity
        // Affects velocity due to different body path
        physicsBody?.mass = GameplayConfiguration.VehiclePhysics.mass
        physicsBody?.allowsRotation = false // Can enable for out of bound fallout animation
        physicsBody?.categoryBitMask = ColliderType.Vehicles
        physicsBody?.collisionBitMask = ColliderType.Vehicles | ColliderType.Obstacles
        physicsBody?.contactTestBitMask = ColliderType.PowerUp | ColliderType.Vehicles | ColliderType.Obstacles
    }

    func turn(_ spinDirection: SpinDirection) {
        switch spinDirection {
        case .Clockwise: direction.turnClockwise()
        case .AntiClockwise: direction.turnAntiClockwise()
        }
        texture = getTexture(prefix: imagePrefix, direction: direction)
        size = texture!.size()
        resetPhysicsBody(direction: direction)
    }

    func accelerate() {
        isAccelerating = true
        isDecelerating = false
        reversePoint = CGFloat(1)
    }

    func decelerate() {
        isDecelerating = true
    }

    func getTexture(prefix: String, direction: Direction) -> SKTexture {
        return SKTexture(imageNamed: "\(prefix)\(direction.name)")
    }

    func update() {
        // NSLog("\(physicsBody?.velocity.magnitude)")
        var dampingFactor = 0.982 // friction
        if isAccelerating, physicsBody!.velocity.magnitude < maxSpeed {
            physicsBody?.applyForce(Sprites.Car.Mass * direction.vector)
        }
        if isDecelerating {
            dampingFactor = 0.93 // increase brake
            // trigger reverse gear when close stopping
            if physicsBody!.velocity.magnitude < reversePoint {
                // increase reverse force frequency
                reversePoint = neutralPoint
                // increase reverse force magnitude
                physicsBody?.applyForce(Sprites.Car.Mass * direction.vector.reversed)
                dampingFactor = 0.97
            } else if physicsBody!.velocity.magnitude < neutralPoint {
                isAccelerating = false
            }
        }
        physicsBody?.velocity *= dampingFactor
    }
}
