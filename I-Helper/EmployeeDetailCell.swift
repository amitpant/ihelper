//
//  EmployeeDetailCell.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 09/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class EmployeeDetailCell: UITableViewCell {

    @IBOutlet weak var empNameLabel: UILabel!
    @IBOutlet weak var noJobDoneLabel: UILabel!
    @IBOutlet weak var empProfilePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
