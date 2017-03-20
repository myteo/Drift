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
        physicsBody?.restitution = 0.9
    }

    func turn(_ direction: SpinDirection, _ percent: CGFloat = 100) {
        guard physicsBody!.velocity.magnitudeSquared > Sprites.Car.minimumTurningSpeed else {
            return
        }
        // Turn magniture is from 0 to 2º, 3º is jittery
        let turnMagnitude = min(SpinDirection.turnDegree * percent / 100, SpinDirection.turnDegree)
        switch direction {
        case .AntiClockwise: zRotation += turnMagnitude
        case .Clockwise: zRotation -= turnMagnitude
        }
        applyDrag()
    }

    func accelerate() {
        isAccelerating = true
    }

    func decelerate() {
        isDecelerating = true
    }

    func getTexture(prefix: String, number: Int) -> SKTexture {
        return SKTexture(imageNamed: "\(prefix)\(number)")
    }

    func update() {
        let force = zRotation.getVector() * Sprites.Car.forceMultiplier
        if isAccelerating {
            physicsBody?.applyForce(force)
        } else if isDecelerating {
            applyDrag()
            if physicsBody!.velocity.magnitude < neutralPoint {
                physicsBody?.applyForce(force.reversed)
            }
        }
    }

    private func applyDrag(_ drag: CGFloat = Sprites.Car.brake) {
        physicsBody?.velocity *= drag
    }
}
