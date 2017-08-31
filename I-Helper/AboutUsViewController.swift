//
//  AboutUsViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol AboutUsViewControllerDelegate: class {
    func aboutUsVCMenuButtonTapped(_ controller: AboutUsViewController)
}


class AboutUsViewController: UIViewController {

    weak var delegate: AboutUsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func MenuButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.aboutUsVCMenuButtonTapped(self)
    }

}
