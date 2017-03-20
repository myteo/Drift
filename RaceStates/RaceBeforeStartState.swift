//
//  File.swift
//  Drift
//
//  Created by Alex on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

// TODO: change this to a gamesceneoverride
class RaceBeforeStartState: GKState {

    unowned let gameScene: GameScene

    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        startCountdown()
    }

    private func startCountdown() {
        // do nothing yet maybe just a print?
        // at the end of the countdown, we can just transition to the next stage
        print("countdown ended!")
        stateMachine?.enter(RaceOngoingState.self)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RaceOngoingState.Type:
            return true
        default: return false
        }
    }
}
