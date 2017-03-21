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
    var isImmune = false

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

    /// Called when Racer activates speed boost PowerUp
    func boostSpeed() {
        physicsBody?.velocity *= GameplayConfiguration.SpeedBoost.currentSpeedBoost
        maxSpeed *= GameplayConfiguration.SpeedBoost.maxSpeedBoost
    }

    /// Called when Racer's speed boost PowerUp ends
    func reduceSpeedToNormal() {
        physicsBody?.velocity /= GameplayConfiguration.SpeedBoost.currentSpeedBoost
        maxSpeed /= GameplayConfiguration.SpeedBoost.maxSpeedBoost
    }

    /// Called when Racer sets trap
    func setTrap() {
        let trapTexture = SKTexture(image: #imageLiteral(resourceName: "bananaPeel"))
        let trapSprite = TrapSprite(texture: trapTexture)
        guard let gameScene = scene as? GameScene else {
            return
        }
        let xComponent = sin(zRotation.negated())
        let yComponent = cos(zRotation)
        // 0.65*size.height is the distance the trap should be away from the center of the vehicle
        let rotationVector = CGVector(dx: xComponent,
                                      dy: yComponent).unitVector.reversed * 0.85 * size.height
        let trapPosition = CGPoint(x: position.x + rotationVector.dx,
                                   y: position.y + rotationVector.dy)
        trapSprite.initTrap(at: trapPosition)
        let trap = Trap(spriteNode: trapSprite)
        gameScene.entityManager.add(trap)
    }

    /// Called when Racer activates immunity PowerUp
    func gainImmunity() {
        isImmune = true
    }

    func loseImmunity() {
        isImmune = false
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
