//
//  Session.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol SessionDelegate: class {

    func connecting(to peer: MCPeerID)

    func connected(to peer: MCPeerID)

    func disconnected(from peer: MCPeerID)

    func received(data: Data, from peer: MCPeerID)

}

class Session: NSObject {

    // TODO: Allow users to customize their display name.
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    lazy var session: MCSession = {
        let session = MCSession(peer: self.peerID,
            securityIdentity: MultipeerConstants.defaultSecurityIdentity,
            encryptionPreference: MultipeerConstants.defaultEncryptionPreference)
        session.delegate = self
        return session
    }()

    weak var sessionDelegate: SessionDelegate?

    func isConnected() -> Bool {
        return session.connectedPeers.count > 0
    }

    func getConnectedPeers() -> [MCPeerID] {
        return session.connectedPeers
    }

    func send(data: Data, mode: MCSessionSendDataMode) {
        try? self.session.send(data, toPeers: session.connectedPeers, with: mode)
    }

}

extension Session: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected: self.sessionDelegate?.connected(to: peerID)
            case .connecting: self.sessionDelegate?.connecting(to: peerID)
            case .notConnected: self.sessionDelegate?.disconnected(from: peerID)
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.sessionDelegate?.received(data: data, from: peerID)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // do nothing for now
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // do nothing for now
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        // do nothing for now
    }
}
