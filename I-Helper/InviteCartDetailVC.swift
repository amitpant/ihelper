//
//  InviteCartDetailVC.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 10/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit
//import FirebaseDatabase
import Firebase

class InviteCartDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
     lazy var dataBaseRef: DatabaseReference = Database.database().reference()
     var channelRefHandle: DatabaseHandle?
    
    
    var job:Job?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 140
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    
    }

   

}

extension InviteCartDetailVC:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let job = job, let emp_list = job.emp_list else {
            return 0
        }
        return emp_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let inviteCartJobCell = tableView.dequeueReusableCell(withIdentifier: "InviteCartJobDetailTVC", for: indexPath) as? InviteCartJobDetailTVC,  let job = job, let emp_list = job.emp_list else {
            return UITableViewCell()
        }
        let employee = emp_list[indexPath.row]
        if let strEmpId = employee.id, let empID = Int(strEmpId)  {
            inviteCartJobCell.chatButton.tag = empID
        }
        
        inviteCartJobCell.delegate = self
        inviteCartJobCell.item = employee
        inviteCartJobCell.selectionStyle = .none
        return inviteCartJobCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let inviteCartHeaderVw = tableView.dequeueReusableCell(withIdentifier: "JobDetailHeaderViewTVC") as? JobDetailHeaderViewTVC   else {
            return nil
        }
        if  let job = job {
            inviteCartHeaderVw.nameLabel.text = job.title
            inviteCartHeaderVw.descriptionLabel.text = job.description
        }
        
        return inviteCartHeaderVw
    }


}
extension InviteCartDetailVC:InviteCartJobDetailTVCDelegate{
    func openChatView(empid:Int) {
        if let data = UserDefaults.standard.data(forKey: "userObject") {
            guard let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) as? User
                else{
                    return
            }
            
            guard let job = job else { return  }
            let chatRoomID = "\(user.user_id)_\(job.job_id)_\(empid)"
           
            print(chatRoomID)
            
            guard let chatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController" ) as? ChatViewController else {
                return
            }
            chatViewController.title = "Chat"
            
            chatViewController.chatRoomId = chatRoomID
            chatViewController.senderDisplayName = user.name
            chatViewController.channelRef = dataBaseRef.child(chatRoomID)
            self.navigationController?.pushViewController(chatViewController, animated: true)
            
        }
    }
}
