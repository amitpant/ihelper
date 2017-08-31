//
//  InviteCartJobDetailTVC.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 10/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol InviteCartJobDetailTVCDelegate:class {
    func openChatView(empid:Int)
}

class InviteCartJobDetailTVC: UITableViewCell {

    weak var delegate:InviteCartJobDetailTVCDelegate?
    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            profileImage?.contentMode = .scaleAspectFill
            profileImage?.layer.cornerRadius = (profileImage?.frame.size.width)!/2
            profileImage?.clipsToBounds = true
            profileImage?.backgroundColor = UIColor.gray
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var paymentButton: UIButton!
    
    var item:Employee?{
        didSet{
            guard let item = item else {
                return
            }
            nameLabel.text = item.name
            if let profile_pic = item.profile_pic, let imageURl = URL(string:profile_pic) {
                profileImage.ap_setImage(url: imageURl)
            }
            if item.status == "0"{
                requestImage.image = UIImage(named: "ic_pending")
                requestLabel.text = "Pending"
                chatButton.isHidden = true
                paymentButton.isHidden = true
            }
            else if item.status == "1"{
                requestImage.image = UIImage(named: "ic_accept")
                requestLabel.text = "Accepted"
                chatButton.isHidden = false
                paymentButton.isHidden = false
                
            }
            else if item.status == "2"{
                requestImage.image = UIImage(named: "ic_cancel")
                requestLabel.text = "Rejected"
                chatButton.isHidden = true
                paymentButton.isHidden = true
            }
    }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func chatPressed(_ sender: UIButton) {
        
        delegate?.openChatView(empid: sender.tag)
    }
}
