//
//  Vehicle.swift
//  Drift
//
//  Created by Leon on 9/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit

class VehicleSprite: SKSpriteNode {

    var isMoving = true
    var imagePrefix = Sprites.Car.Colors.Black
    var isAccelerating = false
    var isDecelerating = false

    let maxSpeed = GameplayConfiguration.VehiclePhysics.maxSpeed
    let neutralPoint = CGFloat(70)
    var reversePoint = CGFloat(1)

    func initVehicle(name: String, number: Int = 1) {
        imagePrefix = name
        texture = getTexture(prefix: name, number: number)
        zRotation = CGFloat() // set euler angle to point to North
        setPhysicsBody()
    }

    func setPhysicsBody() {
        var previousVelocity = CGVector()
        if let v = physicsBody?.velocity {
            previousVelocity = v
        }
        physicsBody = SKPhysicsBody(texture: texture!, size: texture!.size())
        physicsBody?.velocity = previousVelocity
        physicsBody?.mass = GameplayConfiguration.VehiclePhysics.mass
        physicsBody?.categoryBitMask = ColliderType.Vehicles
        physicsBody?.collisionBitMask = ColliderType.Vehicles | ColliderType.Obstacles
        physicsBody?.contactTestBitMask = ColliderType.PowerUp | ColliderType.Vehicles | ColliderType.Obstacles
    }

    func turn(direction: SpinDirection) {
        switch direction {
        case .AntiClockwise: zRotation += CGFloat.π_4
        case .Clockwise: zRotation -= CGFloat.π_4
        }
    }

    func accelerate() {
        isAccelerating = true
        isDecelerating = false
    }

    func decelerate() {
        isAccelerating = true
    }

    func getTexture(prefix: String, number: Int) -> SKTexture {
        return SKTexture(imageNamed: "\(prefix)\(number)")
    }

    func update() {
        var dampingFactor = 0.7 // friction
        // NSLog("\(physicsBody?.velocity.magnitude)")
        if isAccelerating, physicsBody!.velocity.magnitude < maxSpeed {
            physicsBody?.applyForce(zRotation.getVector() * Sprites.Car.Mass * 2)
        }
        if isDecelerating {
            dampingFactor = 0.93 // increase brake
            // trigger reverse gear when close stopping
            if physicsBody!.velocity.magnitude < reversePoint {
                // increase reverse force frequency
                reversePoint = neutralPoint
                // increase reverse force magnitude
                physicsBody?.applyForce(zRotation.getVector() * -Sprites.Car.Mass * 2)
                dampingFactor = 0.97
            } else if physicsBody!.velocity.magnitude < neutralPoint {
                isAccelerating = false
            }
        }
        physicsBody?.velocity *= dampingFactor
    }
}
