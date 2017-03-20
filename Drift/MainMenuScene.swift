//
//  MainMenuScene.swift
//  Drift
//
//  Created by Leon on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    var allMenuCars = [SKSpriteNode]()
    var nextScene = GKScene()
    var nextSceneNode = GKScene()

    override func didMove(to view: SKView) {
        allMenuCars.append(childNode(withName: Sprites.Menu.car1Name) as! SKSpriteNode)
        allMenuCars.append(childNode(withName: Sprites.Menu.car2Name) as! SKSpriteNode)
        allMenuCars.append(childNode(withName: Sprites.Menu.car3Name) as! SKSpriteNode)
        allMenuCars.append(childNode(withName: Sprites.Menu.car4Name) as! SKSpriteNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            guard let node = nodes(at: location).first else {
                return
            }
            switch node.name! {
            case "SinglePlayer":
                // Load 'GameScene.sks' as a GKScene. 
                // This provides gameplay related content including entities and graphs.
                nextScene = GKScene(fileNamed: "GameScene")!
                allMenuCars[1].run(SKAction.moveBy(x: 0, y: Sprites.Menu.car2Y, duration: Sprites.Menu.duration))
                allMenuCars.first!.run(
                    SKAction.moveBy(x: 0, y: Sprites.Menu.car1Y, duration: Sprites.Menu.duration),
                    completion: transitionSinglePlayer
                )
            case "MultiPlayer":
                allMenuCars.first!.run(
                    SKAction.sequence([
                        SKAction.moveBy(x: 0, y: Sprites.Menu.car2Y, duration: Sprites.Menu.duration),
                        SKAction.wait(forDuration: Sprites.Menu.wait)
                    ]),
                    completion: transitionMultiPlayer
                )
                for i in 1..<allMenuCars.count {
                    allMenuCars[i].run(
                        SKAction.sequence([
                            SKAction.wait(forDuration: Double(i / 4)),
                            SKAction.moveBy(x: 0, y: Sprites.Menu.car2Y, duration: Sprites.Menu.duration)
                        ])
                    )
                }
            case "LevelDesigner":
                allMenuCars.first!.run(
                    SKAction.moveBy(x: 0, y: -Sprites.Menu.car3Y, duration: Sprites.Menu.duration),
                    completion: transitionLevelDesigner
                )
            default: break
            }
        }
    }

    private func transitionSinglePlayer() {
        // Get the SKScene from the loaded GKScene
        if let nextSceneNode = nextScene.rootNode as! GameScene? {
            // Copy gameplay related content over to the scene
            nextSceneNode.graphs = nextScene.graphs
            // Set the scale mode to scale to fit the window
            nextSceneNode.scaleMode = .aspectFill
            // Present the scene
            if let view = self.view {
                let transition = SKTransition.crossFade(withDuration: Sprites.Menu.duration)
                transition.pausesIncomingScene = false
                view.presentScene(nextSceneNode, transition: transition)
                view.ignoresSiblingOrder = true
                view.isMultipleTouchEnabled = true
                view.showsFPS = true
                view.showsNodeCount = true
                view.showsPhysics = true
            }
        }
    }

    private func transitionMultiPlayer() {
    }

    private func transitionLevelDesigner() {
    }
}
