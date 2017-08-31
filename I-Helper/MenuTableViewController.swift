//
//  MenuTableViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    @IBOutlet weak var menuHeaderBgView: UIView!{
        didSet{
            self.menuHeaderBgView.backgroundColor = CommonHelper.mainColor
        }
    }
    var isUserLoggedIn = false
    var isMenuCalled = false
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!{
        didSet{
            userProfilePic?.contentMode = .scaleAspectFill
            userProfilePic?.clipsToBounds = true
            userProfilePic?.layer.cornerRadius = userProfilePic.frame.size.width/2
            
        }
    }
   
   
    override func viewDidLoad() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
       //setUpUserDetails()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpUserDetails()
    }
    
    func setUpUserDetails()  {
        if let data = UserDefaults.standard.data(forKey: "userObject") {
            guard let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) as? User
                else{
                    return
            }
           
            self.userNameLabel.text = user.name
            self.userEmailLabel.text = user.email
            if let userlocation = UserDefaults.standard.string(forKey: "userCurrentLocation"){
                self.userLocationLabel.text = userlocation
            }
            if let imageURL = URL(string:user.profile_pic) {
                 self.userProfilePic.ap_setImage(url: imageURL)
            }
            isUserLoggedIn = true
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        var index = indexPath.row
        if !isUserLoggedIn && index > 0{
            // remove the last cell
            index += 3
        }
        
        switch index {
        case 0:
            sideMenuController?.performSegue(withIdentifier: SideMenuOptions.showHome.getSegue(), sender: nil)
        
        case 1:
            sideMenuController?.performSegue(withIdentifier: SideMenuOptions.showJobs.getSegue(), sender: nil)
            
        case 2:
            sideMenuController?.performSegue(withIdentifier: SideMenuOptions.showMyAccount.getSegue(), sender: nil)
            
        case 3:
            sideMenuController?.performSegue(withIdentifier: SideMenuOptions.showNotification.getSegue(), sender: nil)
            
        case 4:
            sideMenuController?.performSegue(withIdentifier: SideMenuOptions.showAboutUs.getSegue(), sender: nil)
            
        default:
            print("indexPath.row:: \(indexPath.row)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = super.tableView(tableView, numberOfRowsInSection: section)
        
        if !isUserLoggedIn {
            // remove the last cell
            return count - 3
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isUserLoggedIn && indexPath.row > 0 {
            // remove the second cell by skipping it and returning the third cell in its place
            return super.tableView(tableView, cellForRowAt: IndexPath(row: indexPath.row + 3, section: 0))
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
}


