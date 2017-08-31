//
//  InviteCartViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol InviteCartViewControllerDelegate: class {
    func inviteCartDetailVC(_ controller: InviteCartViewController, job: Job)
}


class InviteCartViewController: UIViewController {
    
    weak var delegate: InviteCartViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var parentNavigationController : UINavigationController?
    var invitationList:[Job] = []
    //var selectedJob:Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInviteCart()
    }
    
    func loadUserInviteCart()  {
        if let data = UserDefaults.standard.data(forKey: "userObject") {
            guard let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) as? User
                else{
                    return
            }
            let params = ["user_id":"\(user.user_id)"]//27
            print(params)
            self.loadInviteCartData(params: params)
        }
    }
    
    
    func loadInviteCartData(params: [String : Any])  {
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        NetworkClient.shared.downloadDataWithAPIName(apiname: "invitationList", params: params, success: { [weak self]  (serverResponse) in
            guard let strongSelf = self else{return}
            print(serverResponse)
            if serverResponse["status"] as! Bool && serverResponse["isarray"] as! Bool{
                if let data = serverResponse["data"] as? [[String:Any]] {
                    DispatchQueue.main.async {
                        
                        strongSelf.invitationList =  Job.array(jsonObject: data)
                        strongSelf.title = "Invite Cart(\(strongSelf.invitationList.count))"
                        strongSelf.tableView.reloadData()
                        CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
                    }
                }
            }else{
                print(serverResponse["message"] as! String)
                 CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
            }
            
        }) { (error) in
            print(error)
             CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
        }
    }
    
    
    
}


extension InviteCartViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invitationList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCartTableViewCell", for: indexPath) as? InviteCartTableViewCell else {
            return UITableViewCell()
        }
        
        let job = self.invitationList[indexPath.row]
        
        cell.nameLabel.text = job.title
        cell.descriptionLabel.text = job.description
        if job.is_immediate == "1"{
            cell.scheduleDateLabel.text = "Immediate"
            cell.scheduleDateLabel.textColor = .red
        }
        else{
           
            if let dateString = CommonHelper.getDateFromString(dateString: job.schedule_date, dateFormat: "yyyy-mm-dd HH:mm:ss"), let date = CommonHelper.getStringFromDate(date:dateString , dateFormat: "dd-MMM-yy HH:mm")    {
                cell.scheduleDateLabel.text = date
            }else{
                cell.scheduleDateLabel.text = ""
            }
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let job = self.invitationList[indexPath.row]
        guard let inviteCartDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteCartDetailVC" ) as? InviteCartDetailVC else {
            return
        }
        inviteCartDetailVC.title = "Invitation Detail"
        inviteCartDetailVC.job = job
        self.parentNavigationController?.pushViewController(inviteCartDetailVC, animated: true)
        //let job = self.invitationList[indexPath.row]
        //delegate?.inviteCartDetailVC(self, job: job)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

