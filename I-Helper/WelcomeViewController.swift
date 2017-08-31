//
//  WelcomeViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 02/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit


// MARK: - WelcomeViewControllerDelegate
public protocol WelcomeViewControllerDelegate: class {
    func welcomeViewControllerDonePressed(_ controller: WelcomeViewController)
}

public class WelcomeViewController: UIViewController {

    // MARK: - Injections
    public var delegate: WelcomeViewControllerDelegate?
    
    // MARK: - View Lifecycle
    /*public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }*/
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate?.welcomeViewControllerDonePressed(self)
    }
  

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //UserDefaults.standard.set(true, forKey: "isNotFirstTime")
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
