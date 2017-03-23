//
//  File.swift
//  Drift
//
//  Created by Alex on 22/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import GameplayKit

class CheatingState: GKState, OnCrossedFinishLine {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is InRaceLapState.Type
    }

    func justCrossedStartOfFinishLine() {
        // was an attempt to cheat, do nothing
    }

    func justCrossedEndOfFinishLine() {
        // got out of the finish line, no longer considered cheating
        stateMachine?.enter(InRaceLapState.self)
    }
}
