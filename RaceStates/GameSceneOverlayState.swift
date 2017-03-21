//
//  GameSceneOverlayState.swift
//  Drift
//
//  Created by Alex on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneOverlayState: GKState {
    unowned let gameScene: GameScene

    // overlay to display after entering this state
    var overlay: SceneOverlay!

    var overlaySceneFileName: String {
        fatalError("No scene set! Please override this variable")
    }

    init(gameScene: GameScene) {
        self.gameScene = gameScene

        super.init()
        overlay = SceneOverlay(overlayFileName: overlaySceneFileName)
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        overlay.attachOverlay(destination: gameScene)
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)

        overlay.removeOverlay()
    }
}
