//
//  LapTrackerComponent.swift
//  Drift
//
//  Created by Alex on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import GameplayKit

class LapTrackerComponent: GKComponent, OnCrossedFinishLine {

    let stateMachine: GKStateMachine
    private (set) var currentLap: Int = 0 {
        willSet {
            // do win game logic here!
        }
        didSet {
            print("Current lap: \(currentLap)")
        }
    }
    private var tracker: SKNode?

    init(entity: GKEntity, sprite: SKSpriteNode) {
        stateMachine = GKStateMachine(states: [InRaceLapState(),
                                               CheatingState(),
                                               CrossedStartOfFinishLineState()])

        stateMachine.enter(InRaceLapState.self)
        super.init()
        addTrackerToSprite(entity: entity, sprite: sprite)
    }

    private func addTrackerToSprite(entity: GKEntity, sprite: SKSpriteNode) {
        let node = SKNode()
        sprite.addChild(node)
        node.position = CGPoint.zero
        node.entity = entity

        let physicsBody = SKPhysicsBody(circleOfRadius: 1)
        physicsBody.allowsRotation = false
        physicsBody.pinned = true
        physicsBody.collisionBitMask = 0
        physicsBody.categoryBitMask = ColliderType.LapTracker
        physicsBody.contactTestBitMask = ColliderType.FinishLineStart | ColliderType.FinishLineEnd
        node.physicsBody = physicsBody
        tracker = node
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func justCrossedStartOfFinishLine() {
        guard let state = stateMachine.currentState as? OnCrossedFinishLine else {
            return
        }

        state.justCrossedStartOfFinishLine()
    }

    func justCrossedEndOfFinishLine() {
        guard let state = stateMachine.currentState as? OnCrossedFinishLine else {
            return
        }

        if stateMachine.currentState is CrossedStartOfFinishLineState {
            currentLap = currentLap + 1
        }
        state.justCrossedEndOfFinishLine()
    }

}
