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

    override func didMove(to view: SKView) {
        allMenuCars.append(childNode(withName: Sprites.Menu.car1Name) as! SKSpriteNode)
        allMenuCars.append(childNode(withName: Sprites.Menu.car2Name) as! SKSpriteNode)
        allMenuCars.append(childNode(withName: Sprites.Menu.car3Name) as! SKSpriteNode)
        allMenuCars.append(childNode(withName: Sprites.Menu.car4Name) as! SKSpriteNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            var scene = GKScene()
            guard let node = nodes(at: location).first else {
                return
            }
            let transition = {
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! GameScene? {
                    // Copy gameplay related content over to the scene
                    sceneNode.graphs = scene.graphs

                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFill
                    // Present the scene
                    if let view = self.view {
                        let transition = SKTransition.crossFade(withDuration: 1)
                        transition.pausesIncomingScene = false
                        view.presentScene(sceneNode, transition: transition)
                        view.ignoresSiblingOrder = true
                        view.isMultipleTouchEnabled = true

                        view.showsFPS = true
                        view.showsNodeCount = true
                        view.showsPhysics = true
                    }
                }
            }

            switch node.name! {
            case "SinglePlayer":
                // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
                // including entities and graphs.
                scene = GKScene(fileNamed: "GameScene")!
                allMenuCars[1].run(SKAction.moveBy(x: 0, y: Sprites.Menu.car2Y, duration: Sprites.Menu.duration))
                allMenuCars.first!.run(
                    SKAction.moveBy(x: 0, y: Sprites.Menu.car1Y, duration: Sprites.Menu.duration),
                    completion: transition
                )
            case "MultiPlayer":
//                scene = GKScene(fileNamed: "LobbyScene")!
                scene = GKScene(fileNamed: "GameScene")!
                allMenuCars.first!.run(
                    SKAction.sequence([
                        SKAction.moveBy(x: 0, y: Sprites.Menu.car2Y, duration: Sprites.Menu.duration),
                        SKAction.wait(forDuration: Sprites.Menu.wait)
                    ]),
                    completion: transition
                )
                for i in 1..<allMenuCars.count {
                    allMenuCars[i].run(
                        SKAction.sequence([
                            SKAction.wait(forDuration: Double(i / 4)),
                            SKAction.moveBy(x: 0, y: Sprites.Menu.car2Y, duration: Sprites.Menu.duration)
                        ])
                    )
                }
            default: break
            }
        }
    }

}
