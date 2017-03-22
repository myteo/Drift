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
    var forceReduction: CGFloat = 1.0
    var forceIncrement: CGFloat = 1.0
    var isImmobilized = false
    var isImmune = false

    var maxSpeed = GameplayConfiguration.VehiclePhysics.maxSpeed
    let neutralPoint = CGFloat(100)
    var reversePoint = CGFloat(1)

    func initVehicle(name: String, number: Int = 1) {
        imagePrefix = name
        texture = getTexture(prefix: name, number: number)
        zRotation = CGFloat() // set euler angle to point to North
        setPhysicsBody(size: texture!.size())
    }

    func setPhysicsBody(size: CGSize) {
        var previousVelocity = CGVector()
        if let v = physicsBody?.velocity {
            previousVelocity = v
        }
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
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
        physicsBody?.velocity *= GameplayConfiguration.PowerUps.speedBoost
        forceIncrement = GameplayConfiguration.PowerUps.speedBoost
    }

    /// Called when Racer's speed boost PowerUp ends
    func reduceSpeedToNormal() {
        forceIncrement = 1.0
    }

    /// Called when Racer sets trap
    func setTrap() {
        let trapTexture = SKTexture(image: #imageLiteral(resourceName: "bananaPeel"))
        let trapSprite = TrapSprite(texture: trapTexture)
        guard let gameScene = scene as? GameScene else {
            return
        }
        // 0.85*size.height is the distance the trap should be away from the center of the vehicle
        let direction = zRotation.getVector().reversed.unitVector * 0.85 * size.height
        let trapPosition = CGPoint(x: position.x + direction.dx,
                                  y: position.y + direction.dy)
        trapSprite.initTrap(at: trapPosition)
        let trap = Trap(spriteNode: trapSprite, entityManager: gameScene.entityManager)
        gameScene.entityManager.add(trap)
    }

    func immobilize() -> Bool {
        guard !isImmune else {
            return false
        }
        isImmobilized = true
        return true
    }

    /// Called when Racer activates immunity PowerUp
    func gainImmunity() {
        isImmune = true
    }

    /// Called when Racer's immunity PowerUp ends
    func loseImmunity() {
        isImmune = false
    }

    func hitByFrostBullet() -> Bool {
        guard !isImmune else {
            return false
        }
        physicsBody?.velocity *= GameplayConfiguration.PowerUps.speedReduction
        forceReduction = GameplayConfiguration.PowerUps.speedReduction
        return true
    }

    func defrost() {
        forceReduction = 1.0
    }

    func downSize() {
        size /= 2
        setPhysicsBody(size: size)
        physicsBody?.velocity *= GameplayConfiguration.PowerUps.speedReduction
        forceReduction = 0.5
    }

    func endDownSize() {
        size *= 2
        setPhysicsBody(size: size)
        forceReduction = 1
    }

    func getTexture(prefix: String, number: Int) -> SKTexture {
        print("Getting \(prefix) and \(number)")
        return SKTexture(imageNamed: "\(prefix)\(number)")
    }

    func update() {
        guard !isImmobilized else {
            return
        }
        let force = zRotation.getVector() * Sprites.Car.mass * forceReduction * forceIncrement
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
