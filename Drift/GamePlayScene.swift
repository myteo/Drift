//
//  GameScene.swift
//  Drift
//
//  Created by Leon on 8/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    // Scene Nodes
    var car: SKSpriteNode!

    // Tile Map Nodes
    var waterBGs = [SKTileMapNode]()
    var grassBGs = [SKTileMapNode]()
    var roadBGs = [SKTileMapNode]()
    var obstacleBG: SKTileMapNode!
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        loadSceneNodes()
        setupObjects()
    }
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    func loadSceneNodes() {
        // Car
        guard let car = childNode(withName: "Car") as? SKSpriteNode else {
            fatalError("Car Sprite Node not loaded")
        }
        self.car = car
        
        // Grass Tiles
        Tiles.GrassNodeNames.forEach { grassName in
            guard let grassBG = childNode(withName: grassName) as? SKTileMapNode else {
                fatalError("\(grassName) node not loaded")
            }
            grassBGs.append(grassBG)
            grassBG.tileSize.height = Tiles.Height
        }

        // Water Tiles
        guard let waterBG = childNode(withName: "Water") as? SKTileMapNode else {
            fatalError("water node not loaded")
        }
        waterBGs.append(waterBG)
        waterBG.tileSize.height = Tiles.Height
        
        // Road Tiles
        Tiles.RoadNodeNames.forEach { roadName in
            guard let roadBG = childNode(withName: roadName) as? SKTileMapNode else {
                fatalError("\(roadName) node not loaded")
            }
            roadBGs.append(roadBG)
            roadBG.tileSize.height = Tiles.Height
        }
    }
    
    func setupObjects() {
        setupObstacles()
    }
    
    func setupObstacles() {
        let numberOfObjects = 300
        for _ in 1...numberOfObjects {
            let column = Int.random(Tiles.Columns)
            let row = Int.random(Tiles.Rows)
            let grassBG = grassBGs[Int.random(grassBGs.count)]
            if let _ = grassBG.tileDefinition(atColumn: column, row: row) {
                NSLog("\(row) \(column)")
                let treeSprite = SKSpriteNode(imageNamed: "treeShort")
                var grassTileCenter = grassBG.centerOfTile(atColumn: column, row: row)
                grassTileCenter.x += CGFloat(Int.random(Int(Tiles.Width) / 3))
                grassTileCenter.y += CGFloat(Int.random(Int(Tiles.Height) / 3))
                treeSprite.position = grassTileCenter
                addChild(treeSprite)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            switch nodes(at: location)[0].name! {
            case Sprites.AntiClockwiseName:
                // turn ac
                break
            case Sprites.ClockwiseName:
                // turn c
                break
            default: break
            }
        }
    }
    
    func turnAC() {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
