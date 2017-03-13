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
    var graphs = [String : GKGraph]()

    // Entity-Component System
    var entityManager: EntityManager!
    
    // Camera
    var mainCamera: SKCameraNode!
    
    // Scene Nodes
    var player: Vehicle!
    var playerRacer: PlayerRacer!
    var AI: AIRacer!
    var aiMovementBoundaries: [SKNode]!
    var aiMovementWaypoints: [CGPoint]!

    // Tile Map Nodes
    var waterBGs = [SKTileMapNode]()
    var grassBGs = [SKTileMapNode]()
    var roadBGs = [SKTileMapNode]()
    var obstacleBG: SKTileMapNode!
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        loadSceneNodes()
        setupEntities()
        setupObjects()
        setupCamera()
    }
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
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
        setupAIMovement()
        setupAIRacers()
        setupObstacles()
    }
    
    func setupPlayer() {
        // Use node in GamePlayScene.sks to get position
        player = self.childNode(withName: "Car") as! Vehicle
        player.initVehicle(name: Sprites.Car.Colors.Black)
        playerRacer = PlayerRacer(spriteNode: player, entityManager: entityManager)
        entityManager.add(playerRacer)
        
        // If want to set position manually
        // player.position = Sprites.StartLane.First
        // addChild(player)
    }
    
    func setupAIMovement() {
        aiMovementBoundaries = []
        let aiMovementContainer = self.childNode(withName: "Boundaries")!
        for child in aiMovementContainer.children {
            aiMovementBoundaries.append(child)
        }

        aiMovementWaypoints = []
        let aiWaypointContainer = self.childNode(withName: "Waypoints")!
        for child in aiWaypointContainer.children {
            let positionInScene = convert(child.position, from: aiWaypointContainer)
            aiMovementWaypoints.append(positionInScene)
        }
    }

    func setupAIRacers() {
        if let vehicles = self.childNode(withName: "AIs")?.children {
            for vehicle in vehicles {
                let vehicleSpriteNode = vehicle as! Vehicle
                vehicleSpriteNode.initVehicle(name: Sprites.Car.Colors.Blue)
                AI = AIRacer(spriteNode: vehicleSpriteNode, entityManager: entityManager)
                entityManager.add(AI)
            }
        }
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
            case Sprites.Names.Accelerator: player.accelerate()
            case Sprites.Names.Brake: player.decelerate()
            case Sprites.Names.Weapon: playerRacer.fireWeapon()
            case Sprites.Names.AntiClockwise: player.turn(SpinDirection.AntiClockwise)
            case Sprites.Names.Clockwise: player.turn(SpinDirection.Clockwise)
            default: break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let spriteName = nodes(at: location)[0].name
                , spriteName == Sprites.Names.Brake {
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
        
        // Default GameKit boilerplate
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        entityManager.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
    }
}
