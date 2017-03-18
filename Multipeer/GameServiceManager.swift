//
//  GameServiceManager.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

enum GameServiceMessageType: Int {
    case Position = 0
    case Rotation
}

class GameServiceMessage: NSObject, NSCoding {

    let messageType: GameServiceMessageType
    let messageBody: GameServiceMessageBody
    
    init(messageType: GameServiceMessageType, messageBody: GameServiceMessageBody) {
        self.messageType = messageType
        self.messageBody = messageBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        guard let messageType = GameServiceMessageType(rawValue: aDecoder.decodeInteger(forKey: "GameMessageType")),
            let messageBody = aDecoder.decodeObject(forKey: "GameMessageBody") as? GameServiceMessageBody else {
            return nil
        }
        
        self.messageType = messageType
        self.messageBody = messageBody
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(messageType.rawValue, forKey: "GameMessageType")
        aCoder.encode(messageBody, forKey: "GameMessageBody")
    }

}

class GameServiceMessageBody: NSObject, NSCoding {
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        // do nothing, subclasses should override this
    }
    
    func encode(with aCoder: NSCoder) {
        // do nothing, subclasses should override this
    }
}

class GamePosition: GameServiceMessageBody {
    let position: CGPoint
    
    init(position: CGPoint) {
        self.position = position
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.position = aDecoder.decodeCGPoint(forKey: "GamePositionKey")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(position, forKey: "GamePositionKey")
    }
}

class GameRotation: GameServiceMessageBody {
    let rotation: CGFloat
    
    init(rotation: CGFloat) {
        self.rotation = rotation
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let rotationFloat = aDecoder.decodeObject(forKey: "GameRotationKey") as? CGFloat else {
            return nil
        }
        
        self.rotation = rotationFloat
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(rotation, forKey: "GameRotationKey")
    }

}

protocol GameServiceManagerDelegate: class {

    func connecting(to peerID: MCPeerID)

    func connected(to peerID: MCPeerID)

    func disconnected(from peerID: MCPeerID)

    func positionChanged(for peerID: MCPeerID, to position: CGPoint)

    func rotationChanged(for peerID: MCPeerID, to rotation: CGFloat)

}

class GameServiceManager: GameService {

    fileprivate weak var delegate: GameServiceManagerDelegate?
    private lazy var multipeerService: MultipeerService = {
        let multipeerService = MultipeerServiceManager()
        multipeerService.set(sessionDelegate: self)
        multipeerService.searchForPeers()
        return multipeerService
    }()

    func set(delegate: GameServiceManagerDelegate) {
        self.delegate = delegate
    }

    func update(position: CGPoint) {

        let body = GamePosition(position: position)
        let message = GameServiceMessage(messageType: .Position, messageBody: body)
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        multipeerService.send(data: data, mode: .unreliable)
    }
    
    func update(rotation: CGFloat) {
        let body = GameRotation(rotation: rotation)
        let message = GameServiceMessage(messageType: .Rotation, messageBody: body)
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        
        multipeerService.send(data: data, mode: .unreliable)
    }
}

extension GameServiceManager: SessionDelegate {

    // Might want to extract the first 3 into a parent class to inherit these..
    func connecting(to peerID: MCPeerID) {
        delegate?.connected(to: peerID)
    }

    func connected(to peerID: MCPeerID) {
        delegate?.connected(to: peerID)
    }

    func disconnected(from peerID: MCPeerID) {
        delegate?.disconnected(from: peerID)
    }

    func received(data: Data, from peer: MCPeerID) {

        guard let message = NSKeyedUnarchiver.unarchiveObject(with: data) as? GameServiceMessage else {
            print("unreadable message")
            return
        }

        switch message.messageType {
        //TODO: Avoid forced unwrap
        case .Position: self.delegate?.positionChanged(for: peer, to: (message.messageBody as! GamePosition).position)
        case .Rotation: self.delegate?.rotationChanged(for: peer, to: (message.messageBody as! GameRotation).rotation)
        }
    }
}
