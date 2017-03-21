//
//  MainViewController.swift
//  Drift
//
//  Created by Edmund Mok on 21/3/17.
//  Copyright © 2017 nus.cs3217.drift. All rights reserved.
//

import UIKit

/**
 * The main view controller for the application.
 * 
 * This will be our own navigation view controller, but allows us to segue
 * more nicely between view controllers so that the main menu seems like it is part of a game.
 *
 * Only perform segues to and from the actual gameplay.
 */
 class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
