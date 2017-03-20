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
    private (set) var count = 3

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
        stateMachine?.enter(RaceOngoingState.self)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] timer in
            guard let state = self else {
                timer.invalidate()
                return
            }
            
            if state.count == 0 {
                print("GO!")
                timer.invalidate()
            } else {
                print("Count: \(state.count)")
            }
            
            state.count = state.count - 1
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RaceOngoingState.Type:
            return true
        default: return false
        }
    }
}
