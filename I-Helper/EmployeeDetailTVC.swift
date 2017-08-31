//
//  EmployeeDetailTVC.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 11/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class EmployeeDetailTVC: UITableViewCell {
    @IBOutlet weak var empNameLabel: UILabel!
    @IBOutlet weak var empPhoneLabel: UILabel!

    @IBOutlet weak var bgView: UIView!{
        didSet{
            self.bgView.layer.cornerRadius = 8.0
            self.bgView.layer.borderWidth = 3.0
            self.bgView.layer.borderColor = UIColor.lightGray.cgColor
            
        }
    }
    @IBOutlet weak var empProfileImage: UIImageView!{
        didSet{
            empProfileImage?.layer.cornerRadius = (empProfileImage?.frame.size.width)!/2
            empProfileImage?.clipsToBounds = true
            empProfileImage?.contentMode = .scaleAspectFill
            empProfileImage?.backgroundColor = UIColor.lightGray
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

}
