//
//  Alert.swift
//  Drift
//
//  Created by Leon on 20/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import UIKit

struct Alert {

    static func generic(closeHandler: @escaping () -> Void, actions: [UIAlertAction] = [],
                        title: String = "Alert", message: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .cancel, handler: { _ in closeHandler() })
        alert.addAction(close)
        actions.forEach { alert.addAction($0) }
        VC.present(alert, animated: true, completion: nil)
    }

    static func showConfirmAlert(handler: @escaping () -> Void, closeHandler:@escaping () -> Void,
                                 message: String, actionTitle: String, VC: UIViewController) {
        let alert = UIAlertController( title: "Are you sure?", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .destructive, handler: { _ in handler() })
        let close = UIAlertAction(title: "Close", style: .cancel, handler: { _ in closeHandler() })
        alert.addAction(close)
        alert.addAction(action)
        VC.present(alert, animated: true, completion: nil)
    }

}
