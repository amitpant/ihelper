//
//  SendFeedbackComplainTVC.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 11/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol SendFeedbackComplainTVCDelegate: class {
    func showUserFeedback(_ controller: SendFeedbackComplainTVC)
    func showFileComplain(_ controller: SendFeedbackComplainTVC)
}


class SendFeedbackComplainTVC: UITableViewCell {

    weak var delegate:SendFeedbackComplainTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func sendFeedbackPressed(_ sender: UIButton) {
       delegate?.showUserFeedback(self)
    }

    @IBAction func fileComplainPressed(_ sender: UIButton) {
        delegate?.showFileComplain(self)
    }
    
}
