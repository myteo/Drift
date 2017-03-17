//
//  MultipeerServiceManager.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

// API for the multipeer service
// For now, all data is sent through messages. Maybe we can extend the wrapper to
// support streaming / resources too.
protocol MultipeerService {
    
    // Advertise self as a peer and automatically accept invitations from browsers.
    func advertiseForPeers()
    
    // Browse for peers and automatically invite them to join the session.
    func browseForPeers()
    
    // Sends the given data to all connected peers.
    func send(data: Data)
    
    // Sends the given data to the specified peer.
    // Assumes that the specified peer is currently in the session.
    // Otherwise, does nothing.
    func send(data: Data, to peer: MCPeerID)
    
}

class MultipeerServiceManager: NSObject, MultipeerService {
    
    private let session: Session
    private let advertiser: Advertiser
    private let browser: Browser
    
    func advertiseForPeers() {
        <#code#>
    }
    
    func browseForPeers() {
        <#code#>
    }
    
    func send(data: Data) {
        <#code#>
    }
    
    func send(data: Data, to peer: MCPeerID) {
        <#code#>
    }
}
