//
//  SearchCategoryTableViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 17/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class SearchCategoryTableViewController: UITableViewController, UISearchBarDelegate {
    // MARK: - Instance Properties
    internal var categories: [Category] = []

    var filterCategoryList = [SubCategory]()
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return filterCategoryList.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell", for: indexPath) as! SubCategoryTableViewCell
        let subcategory  = filterCategoryList[indexPath.row]
        
        cell.selectionStyle = .none
        cell.subCategoryNameLabel.text = subcategory.sub_cat_name
        if let imageURL = subcategory.sub_cat_image {
            cell.subCategoryImageView.ap_setImage(url: imageURL)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceProviderVC = UIStoryboard(name: Screens.ServiceProviders.name(), bundle: nil).instantiateViewController(withIdentifier: "ServiceProviderViewController") as! ServiceProviderViewController
        let subCategory = self.filterCategoryList[indexPath.row]
        serviceProviderVC.title = subCategory.sub_cat_name
        serviceProviderVC.sub_cat_id = subCategory.sub_cat_id
        self.navigationController?.pushViewController(serviceProviderVC, animated: true)
        
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        self.filterCategoryList = categories.flatMap{$0.sub_category}.filter{$0.sub_cat_name.range(of: searchText) != nil}
       
        tableView.reloadData()
    }
}
