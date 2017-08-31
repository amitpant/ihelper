//
//  SubCategoryTableViewCell.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var subCategoryImageView: UIImageView!{
        didSet{
            self.subCategoryImageView.layer.cornerRadius = 8.0
            self.subCategoryImageView.layer.masksToBounds = true
            self.subCategoryImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var subCategoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
