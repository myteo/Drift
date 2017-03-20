//
//  GameScene.swift
//  Drift
//
//  Created by Leon on 8/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    var graphs = [String: GKGraph]()
    var viewController: UIViewController?
    var motionManager = CMMotionManager()

    // Analog Joystick
    var steeringStick: AnalogJoystick!
    var steeringSprite: SKSpriteNode!
    var brakeSprite: SKSpriteNode!
    var acceleratorSprite: SKSpriteNode!
    var weaponSprite: SKSpriteNode!
    var isUsingJoyStick = true
    var isCameraRotationFixed = true

    // Entity-Component System
    var entityManager: EntityManager!

    // Camera
    var mainCamera: SKCameraNode!
    var pauseBtn: SKSpriteNode!

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
        setupEntities()
        setupObjects()
        setupCamera()
        setupUI()
    }

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }

    private func loadBGNodes() {
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

    private func setupEntities() {
        entityManager = EntityManager(scene: self)
    }

    private func setupObjects() {
        setupPlayer()
        setupAIMovement()
        setupAIRacers()
        setupObstacles()
    }

    private func setupUI() {
        pauseBtn = mainCamera.childNode(withName: Sprites.Names.pauseBtn) as! SKSpriteNode
        weaponSprite = mainCamera.childNode(withName: Sprites.Names.weapon) as! SKSpriteNode
        setupPedals()
        setupSteering()
    }

    private func setupPedals() {
        acceleratorSprite = mainCamera.childNode(withName: Sprites.Names.accelerator) as! SKSpriteNode
        let accelerator = PedalSprite(playerSprite: playerSprite, name: Sprites.Names.accelerator)
        accelerator.position = acceleratorSprite.position
        mainCamera.addChild(accelerator)

        brakeSprite = mainCamera.childNode(withName: Sprites.Names.brake) as! SKSpriteNode
        let brake = PedalSprite(playerSprite: playerSprite, name: Sprites.Names.brake)
        brake.position = brakeSprite.position
        mainCamera.addChild(brake)
    }

    private func setupSteering() {
        steeringSprite = mainCamera.childNode(withName: Sprites.Names.steering) as! SKSpriteNode
        steeringStick = AnalogJoystick(diameters: (200, 100), colors: (UIColor.gray, UIColor.white))
        steeringStick.position = steeringSprite.position
        mainCamera.addChild(steeringStick)
        steeringStick.trackingHandler = { (jData: AnalogJoystickData) in
            // Angular: From top, counter-clockwise: 0 to π, clockwise: 0 to -π
            // NSLog("\(jData.angular), \(jData.velocity.magnitudeSquared)")
            let stickRotation = jData.angular
            let magnitudePercent = jData.velocity.magnitudeSquared / 100
            self.turnPlayer(stickRotation, magnitudePercent, !self.isCameraRotationFixed)
        }
    }

    private func turnPlayer(_ stickRotation: CGFloat, _ magnitudePercent: CGFloat = 100, _ relative: Bool = false) {
        if relative {
            if stickRotation > 0 {
                self.playerSprite.turn(SpinDirection.Clockwise)
            } else {
                self.playerSprite.turn(SpinDirection.AntiClockwise)
            }
            return
        }
        // Only turn when: 25% analog stick displacement & difference greater than 6 degrees
        // to prevent flickering turning
        let zRotation = playerSprite.zRotation
        if magnitudePercent > 25, abs(stickRotation - zRotation) > SpinDirection.degreeLimit {
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

    private func setupPlayer() {
        // Use node in GamePlayScene.sks to get position
        // Specify class of node as "VehicleSprite"
        playerSprite = childNode(withName: "Car") as! VehicleSprite
        playerSprite.initVehicle(name: Sprites.Car.Colors.black)
        playerRacer = PlayerRacer(spriteNode: playerSprite, entityManager: entityManager)
        entityManager.add(playerRacer)
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

    func setupCamera() {
        mainCamera = self.childNode(withName: "MainCamera") as! SKCameraNode
        mainCamera.zPosition = 10
        self.camera = mainCamera
    }

    // MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            switch atPoint(touch.location(in: self)) {
            case weaponSprite: playerRacer.fireWeapon()
            case pauseBtn: createPausePanel()
            default: break
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        playerSprite.update()
        mainCamera.position = playerSprite.position

        if !isCameraRotationFixed {
            updateCameraRotation()
        }

        if !isUsingJoyStick {
            updateTilt()
        }

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

    // MARK: Pause
    private func createPausePanel() {
        self.isPaused = true
        var cameraRotationAction = UIAlertAction(title: "Fix rotation to screen", style: .default, handler: { _ in
            self.fixRotationToScreen()
        })
        if isCameraRotationFixed {
            cameraRotationAction = UIAlertAction(title: "Fix rotation to vehicle", style: .default, handler: { _ in
                self.fixRotationToVehicle()
            })
        }
        var controlSettingAction = UIAlertAction(title: "Use joystick for steering", style: .default, handler: { _ in
            self.useJoystick()
        })
        if isUsingJoyStick {
            controlSettingAction = UIAlertAction(title: "Use tilting for steering", style: .default, handler: { _ in
                self.useTilting()
            })
        }
        let quitAction = UIAlertAction(title: "Exit to Main Menu", style: .destructive, handler: { _ in
            let scene = MainMenuScene(fileNamed: "MainMenuScene")
            scene?.viewController = self.viewController
            Alert.showConfirmAlert(handler: {
                self.view?.presentScene(scene)
            }, closeHandler: {
                self.resumeGame()
            }, message: "Current game progress will be lost.",
               actionTitle: "Yes, leave the game.",
               VC: self.viewController!
            )
        })
        Alert.generic(closeHandler: { self.resumeGame() }, actions: [controlSettingAction, cameraRotationAction, quitAction],
            title: "Game has been paused", message: "Please select an action.", VC: viewController!
        )
    }

    private func resumeGame() {
        isPaused = false
    }

    private func useTilting() {
        isUsingJoyStick = false
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdates()
        steeringStick.isHidden = true
        resumeGame()
    }

    private func useJoystick() {
        isUsingJoyStick = true
        motionManager.stopGyroUpdates()
        steeringStick.isHidden = false
        resumeGame()
    }

    private func fixRotationToScreen() {
        isCameraRotationFixed = true
        mainCamera.zRotation = 0
        resumeGame()
    }

    private func fixRotationToVehicle() {
        isCameraRotationFixed = false
        resumeGame()
    }

    private func updateCameraRotation() {
        mainCamera.zRotation = playerSprite.zRotation
    }

    private func updateTilt() {
        if let attitude = motionManager.deviceMotion?.attitude {
            let tiltRadian = attitude.yaw * 2
            turnPlayer(CGFloat(tiltRadian.getEulerAngleRad()))
        }
    }
}
