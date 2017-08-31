//
//  NotificationViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol NotificationViewControllerDelegate: class {
    func notificationVCMenuButtonTapped(_ controller: NotificationViewController)
}


class NotificationViewController: UIViewController {

    weak var delegate: NotificationViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func MenuButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.notificationVCMenuButtonTapped(self)
    }

}
