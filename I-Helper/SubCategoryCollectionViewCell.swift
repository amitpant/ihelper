//
//  SubCategoryCollectionViewCell.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 01/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class SubCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subCategoryImageView: UIImageView!{
        didSet{
            self.subCategoryImageView.layer.cornerRadius = 8.0
            self.subCategoryImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var subCategoryName: UILabel!
    
  
}
