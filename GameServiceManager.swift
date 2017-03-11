//
//  GameServiceManager.swift
//  Drift
//
//  Created by Edmund Mok on 10/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameServiceManager: NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let DriftServiceType = "drift-service"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    var delegate: GameServiceManagerDelegate?
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId,
                                                           discoveryInfo: nil, serviceType: DriftServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: DriftServiceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func send(colorName: String) {
        NSLog("%@", "sendColor: \(colorName) to \(session.connectedPeers.count) peers")
        
        guard session.connectedPeers.count > 0 else {
            return
        }
        
        // Reliable vs unreliable
        // Unreliable might be faster, but might lose packets.
        // But not really necessary for constantly updating position in game.
        try? self.session.send(colorName.data(using: .utf8)!, toPeers: session.connectedPeers, with: .unreliable)
    }
    
    func update(position: CGPoint) {
        //NSLog("%@", "sending position: \(position) to \(session.connectedPeers.count) peers")

        guard session.connectedPeers.count > 0 else {
            return
        }
                
        let positionString = NSStringFromCGPoint(position)
        try? self.session.send(positionString.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
    }
    
    func update(direction: Direction) {
        NSLog("%@", "sending direction: \(direction) to \(session.connectedPeers.count) peers")
    }
}

extension GameServiceManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        // Note: This code accepts all incoming connections automatically.
        // This would be like a public chat and you need to be very careful to check
        // and sanitize any data you receive over the network as you cannot trust the peers.
        //
        // To keep sessions private the user should be notified and asked to confirm incoming
        // connections. This can be implemented using the MCAdvertiserAssistant classes.
        invitationHandler(true, self.session)
    }
    
}

extension GameServiceManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        // Automatically invite peer
        // Note: This code invites any peer automatically.
        // The MCBrowserViewController class could be used to scan for peers and invite them manually.
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
}

extension GameServiceManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
            session.connectedPeers.map{$0.displayName})
        
        // Just connected
        // Setup the stream
        if state == .connected {
            print("\(peerID) connected")
            
            // Setup player
            self.delegate?.playerJoined(for: peerID, manager: self)
        }
        
        // Disconnected
        // Close the stream
        if state == .notConnected {
            print("\(peerID) disconnected")
            
            self.delegate?.playerLeft(for: peerID, manager: self)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        
        let string = String(data: data, encoding: .utf8)!
        let position = CGPointFromString(string)
        
        print("updating opponent")
        self.delegate?.positionChanged(for: peerID, to: position, manager: self)
        
        //let str = String(data: data, encoding: .utf8)!
        //self.delegate?.colorChanged(manager: self, colorString: str)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}
