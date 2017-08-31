//
//  RunningJobsViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit


protocol RunningJobsViewControllerDelegate: class {
    func showRunningJobsDetail(_ controller: RunningJobsViewController, job: Job)
}


class RunningJobsViewController: UIViewController {
    weak var delegate: RunningJobsViewControllerDelegate?
    
    var runningJobsList:[Job] = []
    var parentNavigationController : UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserRunningJobs()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func loadUserRunningJobs()  {
        if let data = UserDefaults.standard.data(forKey: "userObject") {
            guard let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) as? User
                else{
                    return
            }
            let params = ["user_id":"\(user.user_id)"]//
            print(params)
            self.loadRunningJobsData(params: params)
        }
    }
    func loadRunningJobsData(params: [String : Any])  {
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        NetworkClient.shared.downloadDataWithAPIName(apiname: "onGoingJobs", params: params, success: { [weak self]  (serverResponse) in
            guard let strongSelf = self else{return}
            print(serverResponse)
            if serverResponse["status"] as! Bool && serverResponse["isarray"] as! Bool{
                if let data = serverResponse["data"] as? [[String:Any]] {
                    strongSelf.runningJobsList =  Job.array(jsonObject: data)
                    DispatchQueue.main.async {
                        
                        
                        
                        strongSelf.title = "Running Jobs(\(strongSelf.runningJobsList.count))"
                        
                        strongSelf.tableView.reloadData()
                       
                    }
                }
            }else{
                print(serverResponse["message"] as! String)
               
            }
             CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
            
        }) { (error) in
            print(error)
            CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
        }
    }
}

extension RunningJobsViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.runningJobsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RunningJobTableViewCell", for: indexPath) as? RunningJobTableViewCell else { return UITableViewCell() }
        let job = self.runningJobsList[indexPath.row]
        cell.nameLabel.text = job.title
        cell.descriptionLabel.text = job.description
        if job.is_immediate == "1"{
            cell.scheduleDateLabel.text = "Immediate"
            cell.scheduleDateLabel.textColor = .red
        }else{
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
        let job = runningJobsList[indexPath.row]
        delegate?.showRunningJobsDetail(self, job: job)
    }
}
