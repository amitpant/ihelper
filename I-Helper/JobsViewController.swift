//
//  JobsViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 10/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit
//import PageMenu

class JobsViewController: UIViewController ,CAPSPageMenuDelegate{

    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        
       
       guard let inviteCartVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteCartViewController") as? InviteCartViewController else {
            return
        }
        let storyboard = UIStoryboard(name: "Jobs", bundle: nil)
       // let inviteCartVC = storyboard.instantiateViewController(withIdentifier: "InviteCartViewController") as! InviteCartViewController
        inviteCartVC.delegate =  self
        inviteCartVC.parentNavigationController = self.navigationController
        inviteCartVC.title = "Invite Cart"
        controllerArray.append(inviteCartVC)
        
        guard let jobsRunningVC = self.storyboard?.instantiateViewController(withIdentifier: "RunningJobsViewController") as? RunningJobsViewController else {
            return
        }
        //let jobsRunningVC = storyboard.instantiateViewController(withIdentifier: "RunningJobsViewController") as! RunningJobsViewController
        jobsRunningVC.title = "Running"
        jobsRunningVC.parentNavigationController = self.navigationController
        jobsRunningVC.delegate = self
        controllerArray.append(jobsRunningVC)
        
        guard let jobsHistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "JobHistoryViewController") as? JobHistoryViewController else {
            return
        }
        //let jobsHistoryVC = storyboard.instantiateViewController(withIdentifier: "JobHistoryViewController") as! JobHistoryViewController
        
        jobsHistoryVC.parentNavigationController = self.navigationController
        jobsHistoryVC.title = "History"
        jobsHistoryVC.delegate = self
        
        controllerArray.append(jobsHistoryVC)
              
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(1.0),
            .viewBackgroundColor (UIColor.white),
            .scrollMenuBackgroundColor (UIColor.white),
            .selectionIndicatorColor (CommonHelper.mainColor),
            .selectedMenuItemLabelColor (UIColor.black),
            .unselectedMenuItemLabelColor (UIColor.gray),
            .menuItemSeparatorColor (UIColor.black),
            .menuItemSeparatorRoundEdges (true),
            .selectionIndicatorHeight (0.8)
            // .bottomMenuHairlineColor (UIColor.orange)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame:CGRect(x: 0.0, y: 64.0, width: self.view.frame.width, height: self.view.frame.height - 64.0) , pageMenuOptions: parameters)
        // Optional delegate
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
    }

   /* func willMoveToPage(_ controller: UIViewController, index: Int){
     print("will move to page")
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int){
     print("did move to page")
    }*/
}
extension JobsViewController: InviteCartViewControllerDelegate{
    
    func inviteCartDetailVC(_ controller: InviteCartViewController, job: Job){
        guard let inviteCartDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteCartDetailVC" ) as? InviteCartDetailVC else {
            return
        }
        inviteCartDetailVC.title = "Invitation Detail"
        inviteCartDetailVC.job = job
        self.navigationController?.pushViewController(inviteCartDetailVC, animated: true)
    }
    func openChatVC(){
        guard let chatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController" ) as? ChatViewController else {
            return
        }
        chatViewController.title = "Chat"
        
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
   
}

extension JobsViewController: RunningJobsViewControllerDelegate{
    func showRunningJobsDetail(_ controller: RunningJobsViewController, job: Job) {
        guard let runningJobDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RunningJobDetailVC" ) as? RunningJobDetailVC else {
            return
        }
        runningJobDetailVC.title = "Job Detail"
        runningJobDetailVC.job = job
        runningJobDetailVC.isRunningJob = true
        self.navigationController?.pushViewController(runningJobDetailVC, animated: true)
    }
}

extension JobsViewController: JobHistoryViewControllerDelegate{
    
    func showJobHistoryDetail(_ controller: JobHistoryViewController, job: Job) {
        
            guard let runningJobDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RunningJobDetailVC" ) as? RunningJobDetailVC else {
                return
            }
            runningJobDetailVC.title = "History Job detail"
            runningJobDetailVC.job = job
            runningJobDetailVC.isRunningJob = false
            self.navigationController?.pushViewController(runningJobDetailVC, animated: true)
        
    }
    
   
}
