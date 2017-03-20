//
//  GameViewController.swift
//  Drift
//
//  Created by Leon on 8/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let scene = MainMenuScene(fileNamed: "MainMenuScene") else {
            fatalError("Scene file not found")
        }
        if let view = self.view as! SKView? {
            scene.viewController = self
            view.presentScene(scene)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
