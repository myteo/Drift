//
//  File.swift
//  Drift
//
//  Created by Alex on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class RaceBeforeStartState: GameSceneOverlayState {

    let disappearAfter = 4.5
    override var overlaySceneFileName: String {
        return "RaceBeforeStartOverlay"
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        startCountdown()
    }

    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: disappearAfter, repeats: false) { [weak self] timer in
            guard let state = self else {
                timer.invalidate()
                return
            }

            state.stateMachine?.enter(RaceOngoingState.self)
            timer.invalidate()
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
