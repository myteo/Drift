//
//  GameScene.swift
//  Drift
//
//  Created by Leon on 8/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit
import MultipeerConnectivity

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var gameService = GameServiceManager()

    // Entity-Component System
    var entityManager: EntityManager!
    
    // Camera
    var mainCamera: SKCameraNode!
    
    // Scene Nodes
    var player: Vehicle!

    // Tile Map Nodes
    var waterBGs = [SKTileMapNode]()
    var grassBGs = [SKTileMapNode]()
    var roadBGs = [SKTileMapNode]()
    var obstacleBG: SKTileMapNode!
    
    // Temporary sprite listing
    var otherPlayers = [MCPeerID : Vehicle]()
    
    private var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        loadSceneNodes()
        setupEntities()
        setupObjects()
        setupCamera()
    }
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        gameService.delegate = self
    }
    
    func loadSceneNodes() {
        // Grass Tiles
        Tiles.Grass.NodeNames.forEach { grassName in
            guard let grassBG = childNode(withName: grassName) as? SKTileMapNode else {
                fatalError("\(grassName) node not loaded")
            }
            grassBGs.append(grassBG)
            grassBG.tileSize.height = Tiles.Height
            grassBG.physicsBody?.friction = Tiles.Grass.Friction
        }

        // Water Tiles
        guard let waterBG = childNode(withName: "Water") as? SKTileMapNode else {
            fatalError("water node not loaded")
        }
        waterBGs.append(waterBG)
        waterBG.tileSize.height = Tiles.Height
        
        // Road Tiles
        Tiles.Road.NodeNames.forEach { roadName in
            guard let roadBG = childNode(withName: roadName) as? SKTileMapNode else {
                fatalError("\(roadName) node not loaded")
            }
            roadBGs.append(roadBG)
            roadBG.tileSize.height = Tiles.Height
            roadBG.physicsBody?.friction = Tiles.Road.Friction
        }
    }
    
    func setupEntities() {
        entityManager = EntityManager(scene: self)
    }
    
    func setupObjects() {
        setupPlayer()
        setupObstacles()
    }
    
    func setupPlayer() {
        // Use node in GamePlayScene.sks to get position
        player = self.childNode(withName: "Car") as! Vehicle
        player.initVehicle(name: Sprites.Car.Colors.Black)
        player.position = Sprites.StartLane.First
        
        // If want to set position manually
        // player.position = Sprites.StartLane.First
        // addChild(player)
    }
    
    func setupObstacles() {
        let numberOfObjects = 300
        let collisionRadius = CGFloat(2.1)
        for _ in 1...numberOfObjects {
            let column = Int.random(Tiles.Columns)
            let row = Int.random(Tiles.Rows)
            let grassBG = grassBGs[Int.random(grassBGs.count)]
            if let _ = grassBG.tileDefinition(atColumn: column, row: row) {
                let treeSprite = SKSpriteNode(imageNamed: Sprites.Trees.Names[Int.random(Sprites.Trees.Names.count)])
                let centerOfMass = CGPoint(x: treeSprite.position.x,
                                           y: treeSprite.position.y - treeSprite.size.height/2 + collisionRadius*2)
                treeSprite.physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius, center: centerOfMass)
                treeSprite.physicsBody?.categoryBitMask = ColliderType.Obstacles
                treeSprite.physicsBody?.collisionBitMask = ColliderType.Vehicles
                var grassTileCenter = grassBG.centerOfTile(atColumn: column, row: row)
                let displacement = Int.random(9)
                grassTileCenter.x += CGFloat(displacement)
                grassTileCenter.y += CGFloat(displacement)
                treeSprite.position = grassTileCenter
                treeSprite.zPosition = 10
                addChild(treeSprite)
            }
        }
    }
    
    func setupCamera() {
        mainCamera = self.childNode(withName: "MainCamera") as! SKCameraNode
        mainCamera.zPosition = 10
        self.camera = mainCamera
    }
    
    // MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            guard let spriteName = nodes(at: location)[0].name else {
                return
            }
            switch spriteName {
            case Sprites.AcceleratorName: player.accelerate()
            case Sprites.BrakeName: player.decelerate()
            case Sprites.AntiClockwiseName: player.turn(SpinDirection.AntiClockwise)
            case Sprites.ClockwiseName: player.turn(SpinDirection.Clockwise)
            default: break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let spriteName = nodes(at: location)[0].name
                , spriteName == Sprites.BrakeName {
                player.decelerate()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Only braking depends is ended on release, foot is still on accelerator
        player.isDecelerating = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
        mainCamera.position = player.position
        
        // Send position and direction updates
        gameService.update(position: player.position)
        gameService.update(direction: player.direction)
        
        // Default GameKit boilerplate
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

extension GameScene: GameServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: GameServiceManager, connectedDevices: [String]) {
        NSLog("%@", "connectedDevices: \(connectedDevices)")
    }
    
    func positionChanged(for peerID: MCPeerID, to position: CGPoint, manager: GameServiceManager) {
        // Update the position of other player sprite
        guard let otherPlayer = otherPlayers[peerID] else {
            return
        }
        
        otherPlayer.position = position
    }
    
    func directionChanged(for peerID: MCPeerID, to direction: Direction, manager: GameServiceManager) {
        // Update the direction of other player sprite
        guard let otherPlayer = otherPlayers[peerID] else {
            return
        }
        otherPlayer.direction = direction
    }
    
    func playerJoined(for peerID: MCPeerID, manager: GameServiceManager) {
        // Setup a new sprite for player
        let otherPlayer = Vehicle()
        self.addChild(otherPlayer)
        
        
        // Hard code for 2 players first
        //let otherPlayer = self.childNode(withName: "Car2") as! Vehicle
        otherPlayer.initVehicle(name: Sprites.Car.Colors.Black)
        otherPlayer.position = Sprites.StartLane.First
        otherPlayer.zPosition = 10
        
        print("Added \(peerID) sprite")
        
        // insert to listing
        otherPlayers[peerID] = otherPlayer
    }
    
    func playerLeft(for peerID: MCPeerID, manager: GameServiceManager) {
        // Remove the corresponding sprite of player
        guard let otherPlayer = otherPlayers[peerID] else {
            return
        }
        
        otherPlayer.removeFromParent()
    }
}
