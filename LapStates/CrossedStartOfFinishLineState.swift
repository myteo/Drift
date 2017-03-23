//
//  File.swift
//  Drift
//
//  Created by Alex on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import GameplayKit

class CrossedStartOfFinishLineState: GKState, OnCrossedFinishLine {

    func justCrossedStartOfFinishLine() {
        // do nothing, remain in the same state
    }

    func justCrossedEndOfFinishLine() {
        stateMachine?.enter(InRaceLapState.self)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is InRaceLapState.Type
    }

}
