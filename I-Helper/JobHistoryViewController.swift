//
//  JobHistoryViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit



protocol JobHistoryViewControllerDelegate: class {
    func showJobHistoryDetail(_ controller: JobHistoryViewController, job: Job)
}


class JobHistoryViewController: UIViewController {
    weak var delegate: JobHistoryViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var parentNavigationController : UINavigationController?
    
    var completedJobsList:[Job] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       loadUserJobHistory()
    }
    
    
    func loadUserJobHistory()  {
        if let data = UserDefaults.standard.data(forKey: "userObject") {
            guard let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) as? User
                else{
                    return
            }
            let params = ["user_id":"\(user.user_id)"]//
            print(params)
            self.loadJobHistoryData(params: params)
        }
    }
    func loadJobHistoryData(params: [String : Any])  {
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        NetworkClient.shared.downloadDataWithAPIName(apiname: "jobHistory", params: params, success: { [weak self]  (serverResponse) in
            guard let strongSelf = self else{return}
            print(serverResponse)
            if serverResponse["status"] as! Bool && serverResponse["isarray"] as! Bool{
                if let data = serverResponse["data"] as? [[String:Any]] {
                    strongSelf.completedJobsList =  Job.array(jsonObject: data)
                    DispatchQueue.main.async {
                        strongSelf.title = "Jobs History(\(strongSelf.completedJobsList.count))"
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

extension JobHistoryViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completedJobsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobHistoryTableViewCell", for: indexPath) as? JobHistoryTableViewCell else { return UITableViewCell() }
        let job = self.completedJobsList[indexPath.row]
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
        let job = completedJobsList[indexPath.row]
        delegate?.showJobHistoryDetail(self, job: job)
    }
    
}
