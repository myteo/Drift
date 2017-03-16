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
    let neutralPoint = CGFloat(100)
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
        physicsBody?.angularDamping = 1 // Minimize spinning from collision
    }

    func turn(_ direction: SpinDirection, _ percent: CGFloat) {
        // Turn magniture is from 1 to 6 degrees
        let turnMagnitude = min(SpinDirection.degree * percent / 10 * 6, 6 * SpinDirection.degree)
        switch direction {
        case .AntiClockwise: zRotation += turnMagnitude
        case .Clockwise: zRotation -= turnMagnitude
        }
    }

    func accelerate() {
        isAccelerating = true
        isDecelerating = false
    }

    func decelerate() {
        isDecelerating = true
    }

    func getTexture(prefix: String, number: Int) -> SKTexture {
        return SKTexture(imageNamed: "\(prefix)\(number)")
    }

    func update() {
        // NSLog("\(physicsBody?.velocity.magnitude)")
        if isAccelerating, physicsBody!.velocity.magnitude < maxSpeed {
            physicsBody?.applyForce(zRotation.getVector() * Sprites.Car.Mass * 10)
        }
        if isDecelerating {
            // trigger reverse gear when close stopping
            if physicsBody!.velocity.magnitude < reversePoint {
                reversePoint = neutralPoint
                physicsBody?.applyForce(zRotation.getVector() * -Sprites.Car.Mass * 10)
            } else if physicsBody!.velocity.magnitude < neutralPoint {
                isAccelerating = false
            }
        }
    }
}
