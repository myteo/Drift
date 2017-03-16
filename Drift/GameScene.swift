//
//  GameScene.swift
//  Drift
//
//  Created by Leon on 8/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var graphs = [String: GKGraph]()

    // Analog Joystick
    var steeringStick: AnalogJoystick!
    var steeringSprite: SKSpriteNode!
    var brakeSprite: SKSpriteNode!
    var acceleratorSprite: SKSpriteNode!
    var weaponSprite: SKSpriteNode!

    // Entity-Component System
    var entityManager: EntityManager!

    // Camera
    var mainCamera: SKCameraNode!

    // Scene Nodes
    var playerSprite: VehicleSprite!
    var playerRacer: PlayerRacer!
    var aiMovementBoundaries: [SKNode]!
    var aiMovementWaypoints: [CGPoint]!

    // BG Nodes
    var grassBG: SKTileMapNode!
    var roadBG: SKTileMapNode!
    var treesBG: SKNode!

    private var lastUpdateTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        loadBGNodes()
        setupPhysicsWorld()
        setupEntities()
        setupObjects()
        setupCamera()
        setupUI()
    }

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }

    func loadBGNodes() {
        // Grass Tiles
        guard let grassBG = childNode(withName: "Grass") as? SKTileMapNode else {
            fatalError("Grass Tile set node not loaded")
        }
        self.grassBG = grassBG

        // Road Tiles
        guard let roadBG = childNode(withName: "Road") as? SKTileMapNode else {
            fatalError("Road Tile set node not loaded")
        }
        self.roadBG = roadBG
        treesBG = childNode(withName: "Trees")
    }

    func setupPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }

    func setupEntities() {
        entityManager = EntityManager(scene: self)
    }

    func setupObjects() {
        setupPlayer()
        setupAIMovement()
        setupAIRacers()
        setupObstacles()
        setupPowerUps()
    }

    func setupUI() {
        weaponSprite = mainCamera.childNode(withName: Sprites.Names.weapon) as! SKSpriteNode
        setupPedals()
        setupSteering()
    }

    func setupPedals() {
        acceleratorSprite = mainCamera.childNode(withName: Sprites.Names.accelerator) as! SKSpriteNode
        let accelerator = PedalSprite(playerSprite: playerSprite, name: Sprites.Names.accelerator)
        accelerator.position = acceleratorSprite.position
        mainCamera.addChild(accelerator)

        brakeSprite = mainCamera.childNode(withName: Sprites.Names.brake) as! SKSpriteNode
        let brake = PedalSprite(playerSprite: playerSprite, name: Sprites.Names.brake)
        brake.position = brakeSprite.position
        mainCamera.addChild(brake)
    }

    func setupSteering() {
        steeringSprite = mainCamera.childNode(withName: Sprites.Names.steering) as! SKSpriteNode
        steeringStick = AnalogJoystick(diameters: (200, 100), colors: (UIColor.gray, UIColor.white))
        steeringStick.position = steeringSprite.position
        mainCamera.addChild(steeringStick)
        steeringStick.trackingHandler = { (jData: AnalogJoystickData) in
            // Angular: From top, counter-clockwise: 0 to π, clockwise: 0 to -π
            // NSLog("\(jData.angular), \(jData.velocity.magnitudeSquared)")
            let zRotation = self.playerSprite.zRotation
            let stickRotation = jData.angular
            let magnitudePercent = jData.velocity.magnitudeSquared / 100

            // Only turn when: 25% analog stick displacement & difference greater than 6 degrees
            // to prevent flickering turning
            if magnitudePercent > 25, abs(stickRotation - zRotation) > 6 * SpinDirection.degree {
                if stickRotation > 0 {
                    let opposite = stickRotation - CGFloat.pi
                    if zRotation > opposite, zRotation < stickRotation {
                        self.playerSprite.turn(SpinDirection.AntiClockwise, magnitudePercent)
                    } else {
                        self.playerSprite.turn(SpinDirection.Clockwise, magnitudePercent)
                    }
                } else { // Towards right
                    let opposite = stickRotation + CGFloat.pi
                    if zRotation < opposite, zRotation > stickRotation {
                        self.playerSprite.turn(SpinDirection.Clockwise, magnitudePercent)
                    } else {
                        self.playerSprite.turn(SpinDirection.AntiClockwise, magnitudePercent)
                    }
                }
            }
        }
    }

    func setupPlayer() {
        // Use node in GamePlayScene.sks to get position
        // Specify class of node as "VehicleSprite"
        playerSprite = childNode(withName: "Car") as! VehicleSprite
        playerSprite.initVehicle(name: Sprites.Car.Colors.black)
        playerRacer = PlayerRacer(spriteNode: playerSprite, entityManager: entityManager)
        entityManager.add(playerRacer)

        // If want to set position manually
        // playerSprite.position = Sprites.StartLane.First
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
            for i in 1...vehicles.count {
                let vehicleSpriteNode = vehicles[i-1] as! VehicleSprite
                vehicleSpriteNode.initVehicle(name: Sprites.Car.Colors.blue, number: i)
                let aiRacer = AIRacer(spriteNode: vehicleSpriteNode, entityManager: entityManager)
                entityManager.add(aiRacer)
            }
        }
    }

    func setupObstacles() {
        let numberOfObjects = 100
        for _ in 1...numberOfObjects {
            let column = Int.random(Tiles.Columns)
            let row = Int.random(Tiles.Rows)
            if let _ = grassBG.tileDefinition(atColumn: column, row: row) {
                let treeSprite = SKSpriteNode(imageNamed: Sprites.Trees.Names[1])
                treeSprite.physicsBody = SKPhysicsBody(texture: treeSprite.texture!, size: treeSprite.texture!.size())
                treeSprite.physicsBody?.categoryBitMask = ColliderType.Obstacles
                treeSprite.physicsBody?.collisionBitMask = ColliderType.Vehicles | ColliderType.Obstacles
                treeSprite.physicsBody?.mass = 0.1
                var grassTileCenter = grassBG.centerOfTile(atColumn: column, row: row)
                let displacement = Int.random(9)
                grassTileCenter.x += CGFloat(displacement)
                grassTileCenter.y += CGFloat(displacement)
                treeSprite.position = grassTileCenter
                treeSprite.zPosition = 10
                treesBG.addChild(treeSprite)
            }
        }
    }

    func setupPowerUps() {
        if let powerUps = self.childNode(withName: "PowerUps")?.children {
            for powerUp in powerUps {
                if powerUp.name == "SpeedBoost" {
                    guard let speedBoostSprite = powerUp as? PowerUpSprite else {
                        continue
                    }
                    speedBoostSprite.initPowerUp()
                    let speedBoostEntity = PowerUp(spriteNode: speedBoostSprite,
                                                   entityManager: entityManager)
                    entityManager.add(speedBoostEntity)
                }
            }
        }
    }

    func setupCamera() {
        mainCamera = self.childNode(withName: "MainCamera") as! SKCameraNode
        mainCamera.zPosition = 10
        self.camera = mainCamera
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask ==
            ColliderType.Vehicles | ColliderType.PowerUp else {
                return
        }
        guard let entityA = contact.bodyA.node?.entity,
            let entityB = contact.bodyB.node?.entity else {
                return
        }
        if let notifiableA = entityA as? ContactNotifiableType {
            notifiableA.contactWithEntityDidBegin(entityB)
        }
        if let notifiableB = entityB as? ContactNotifiableType {
            notifiableB.contactWithEntityDidBegin(entityA)
        }
    }

    // MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, weaponSprite == atPoint(touch.location(in: self)) {
            playerRacer.fireWeapon()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    func handleTouches(_ touches: Set<UITouch>) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
        playerSprite.update()
        mainCamera.position = playerSprite.position

        // Default GameKit boilerplate
        // Initialize _lastUpdateTime if it has not already been
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        entityManager.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
    }
}
