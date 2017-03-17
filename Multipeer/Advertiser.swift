//
//  Advertiser.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Advertiser: NSObject {
    
    let peerID: MCPeerID
    let session: MCSession
    fileprivate let serviceAdvertiser: MCNearbyServiceAdvertiser
    
    init(session: MCSession) {
        self.session = session
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.peerID,
            discoveryInfo: nil, serviceType: MultipeerConstants.defaultServiceType)
        self.serviceAdvertiser.delegate = self
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func startAdvertising() {
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
}

extension Advertiser: MCNearbyServiceAdvertiserDelegate {
    
    // For now, there is no find game / host game because multipeer hosts invite people to join the
    // session rather than the standard way where other people look for hosts to join.
    // So current strategy is to accept / invite anyone that is found.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(true, self.session)
    }
}
