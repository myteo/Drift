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

    fileprivate let session: MCSession
    fileprivate lazy var serviceAdvertiser: MCNearbyServiceAdvertiser = {
        let serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.session.myPeerID,
            discoveryInfo: nil, serviceType: MultipeerConstants.defaultServiceType)
        serviceAdvertiser.delegate = self
        return serviceAdvertiser
    }()

    init(session: MCSession) {
        self.session = session
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
