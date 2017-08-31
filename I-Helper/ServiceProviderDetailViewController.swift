//
//  ServiceProviderDetailViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 10/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class ServiceProviderDetailViewController: UIViewController {

    var serviceProvider:ServiceProvider?
    
    var viewModel: ServiceProviderViewModel?
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Provider Detail"
        viewModel = ServiceProviderViewModel(serviceProvider: serviceProvider)
        tableView?.dataSource = viewModel
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        tableView?.register(ServiceProviderDetailsCell.nib, forCellReuseIdentifier: ServiceProviderDetailsCell.identifier)
        tableView?.register(ServiceProviderMapViewCell.nib, forCellReuseIdentifier: ServiceProviderMapViewCell.identifier)
//        tableView?.register(FriendCell.nib, forCellReuseIdentifier: FriendCell.identifier)
//        tableView?.register(AttributeCell.nib, forCellReuseIdentifier: AttributeCell.identifier)
//        tableView?.register(EmailCell.nib, forCellReuseIdentifier: EmailCell.identifier)
    }

}
