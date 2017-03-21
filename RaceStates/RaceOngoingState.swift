//
//  RaceOngoingState.swift
//  Drift
//
//  Created by Alex on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class RaceOngoingState: GKState {

    unowned let gameScene: GameScene

    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        print("Currently in ongoing state")
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RaceEndedState.Type:
            return true
        default: return false
        }
    }

}
