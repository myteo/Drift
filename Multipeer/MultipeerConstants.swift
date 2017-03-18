//
//  MultipeerConstants.swift
//  Drift
//
//  Created by Edmund Mok on 17/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct MultipeerConstants {

    // make them configuration variables later.
    static let defaultServiceType = "default-service"
    static let defaultTimeOut: TimeInterval = 10
    static let defaultSecurityIdentity: [Any]? = nil
    static let defaultEncryptionPreference: MCEncryptionPreference = .none

}
