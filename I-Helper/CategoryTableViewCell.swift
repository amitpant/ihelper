//
//  CategoryTableViewCell.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 01/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol CategoryTableViewCellDelegate:class {
    func viewAllButtonPressed(index:Int)
    func subCategoryCellPressed( subCategory : SubCategory )
}

class CategoryTableViewCell: UITableViewCell {

    weak var delegate:CategoryTableViewCellDelegate?
    
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryHeaderView: GradientView!{
        didSet{
            
            self.categoryHeaderView.layer.cornerRadius = 4.0
           
        }
    }
    
    // MARK: - Instance Properties
     fileprivate var subCategories: [SubCategory] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(_ category:Category) {
        
        self.categoryLabel.text = category.category_name
        
        self.subCategories = category.sub_category
        self.subCategoryCollectionView.reloadData()
    }

    
    @IBAction func viewAllButtonPressed(_ sender: UIButton) {
        
        delegate?.viewAllButtonPressed(index: sender.tag)
    }
    
    
}

extension CategoryTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as! SubCategoryCollectionViewCell
        
            let subcategory = subCategories[indexPath.row]
            
            cell.subCategoryName.text = subcategory.sub_cat_name
            if let imageURL = subcategory.sub_cat_image {
                cell.subCategoryImageView.ap_setImage(url: imageURL)
            }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let subcategory = subCategories[indexPath.row]
        delegate?.subCategoryCellPressed(subCategory: subcategory)
    }
}
