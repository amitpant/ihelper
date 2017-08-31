//
//  RunningJobDetailVC.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 11/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit



class RunningJobDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var job:Job?
    var isRunningJob = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
    }
}

extension RunningJobDetailVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isRunningJob ? 3 : 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var rowIndex = indexPath.row
        if indexPath.row > 1 && isRunningJob {
            rowIndex += 2
        }
        
        switch rowIndex {
        case 0:
            guard let jobDetailTVC = tableView.dequeueReusableCell(withIdentifier: "JobDetailTVC") as? JobDetailTVC, let job = job else {
                return UITableViewCell()
            }
            jobDetailTVC.jobTitleLabel.text = job.title
            jobDetailTVC.descriptionLabel.text = job.description
            jobDetailTVC.noOfJobDoneLabel.isHidden = isRunningJob
            jobDetailTVC.selectionStyle = .none
           return jobDetailTVC
        case 1:
            guard let employeeDetailTVC = tableView.dequeueReusableCell(withIdentifier: "EmployeeDetailTVC") as? EmployeeDetailTVC, let job = job, let employee = job.employee else {
                return UITableViewCell()
            }
            employeeDetailTVC.empNameLabel.text = employee.name
            employeeDetailTVC.empPhoneLabel.text = employee.mobile
            if let profile_pic = employee.profile_pic , let imageURL = URL(string: profile_pic) {
                employeeDetailTVC.empProfileImage.ap_setImage(url: imageURL)
            }
            employeeDetailTVC.selectionStyle = .none
            return employeeDetailTVC
        case 2:
            guard let userRatingTVC = tableView.dequeueReusableCell(withIdentifier: "UserRatingTVC") as? UserRatingTVC, let job = job else {
                return UITableViewCell()
            }
            if let rating = job.rating, let dRating = Double(rating) {
                let irating = Int(dRating)
                userRatingTVC.ratingControl.rating = irating
            }
            
            userRatingTVC.selectionStyle = .none
            return userRatingTVC
        case 3:
            guard let userCommentTVC = tableView.dequeueReusableCell(withIdentifier: "UserCommentTVC") as? UserCommentTVC, let job = job else {
                return UITableViewCell()
            }
            userCommentTVC.commentLabel.text = job.comment
            userCommentTVC.selectionStyle = .none
            return userCommentTVC
        case 4:
            guard let sendFeedbackComplainTVC = tableView.dequeueReusableCell(withIdentifier: "SendFeedbackComplainTVC") as? SendFeedbackComplainTVC else {
                return UITableViewCell()
            }
            sendFeedbackComplainTVC.delegate = self
            sendFeedbackComplainTVC.selectionStyle = .none
            return sendFeedbackComplainTVC
        default:
            return UITableViewCell()
        }
        
    }
    
    
}


extension RunningJobDetailVC: SendFeedbackComplainTVCDelegate{
    func showUserFeedback(_ controller: SendFeedbackComplainTVC) {
        guard let userFeedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "UserFeedbackVC" ) as? UserFeedbackVC, let job = job else {
            return
        }
        userFeedbackVC.job_id = job.job_id
        userFeedbackVC.provider_id = job.provider_id
        userFeedbackVC.title = "Feedback"
        self.navigationController?.pushViewController(userFeedbackVC, animated: true)
    }
    
    func showFileComplain(_ controller: SendFeedbackComplainTVC) {
        guard let fileComplainVC = self.storyboard?.instantiateViewController(withIdentifier: "FileComplainVC" ) as? FileComplainVC, let job = job else {
            return
        }
        fileComplainVC.job_id = job.job_id
        fileComplainVC.title = "File Complain"
        self.navigationController?.pushViewController(fileComplainVC, animated: true)
    }
}



