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
    var imagePrefix = Sprites.Car.Colors.black
    var isAccelerating = false
    var isDecelerating = false
    var isPoweredUp = false

    var maxSpeed = GameplayConfiguration.VehiclePhysics.maxSpeed
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
        physicsBody?.restitution = 0.9
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
    }

    func decelerate() {
        isDecelerating = true
    }

    /// Called when vehicle touches speed boost PowerUp
    func boostSpeed() {
        guard !isPoweredUp else {
            return
        }
        isPoweredUp = true
        physicsBody?.velocity *= GameplayConfiguration.SpeedBoost.currentSpeedBoost
        maxSpeed *= GameplayConfiguration.SpeedBoost.maxSpeedBoost
        DispatchQueue.main.asyncAfter(deadline: .now() +
            GameplayConfiguration.SpeedBoost.speedBoostDuration, execute: {
                self.physicsBody?.velocity /= GameplayConfiguration.SpeedBoost.currentSpeedBoost
                self.maxSpeed /= GameplayConfiguration.SpeedBoost.maxSpeedBoost
                self.isPoweredUp = false
        })
    }

    /// Called when vehicle touches speed reduction PowerUp
    func reduceSpeed() {
        guard !isPoweredUp else {
            return
        }
        isPoweredUp = true
        physicsBody?.velocity /= GameplayConfiguration.SpeedReduction.currentSpeedReduction
        maxSpeed /= GameplayConfiguration.SpeedReduction.maxSpeedReduction
        DispatchQueue.main.asyncAfter(deadline: .now() +
            GameplayConfiguration.SpeedReduction.speedReductionDuration, execute: {
                self.physicsBody?.velocity *= GameplayConfiguration.SpeedReduction.currentSpeedReduction
                self.maxSpeed *= GameplayConfiguration.SpeedReduction.maxSpeedReduction
                self.isPoweredUp = false
        })
    }

    func getTexture(prefix: String, number: Int) -> SKTexture {
        print("Getting \(prefix) and \(number)")
        return SKTexture(imageNamed: "\(prefix)\(number)")
    }

    func update() {
        let force = zRotation.getVector() * Sprites.Car.mass
        if isAccelerating {
            physicsBody?.applyForce(force)
        } else if isDecelerating {
            physicsBody?.velocity *= 0.95
            if physicsBody!.velocity.magnitude < neutralPoint {
                physicsBody?.applyForce(force.reversed)
            }
        }
    }
}
