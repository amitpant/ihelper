//
//  SubCategoryTableViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class SubCategoryTableViewController: UITableViewController {

    var subcategoryList = [SubCategory]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }

    func setUpView(title:String, subcategoryList:[SubCategory])  {
        self.title = title
        self.subcategoryList = subcategoryList
        self.tableView.reloadData()
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
        return subcategoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell", for: indexPath) as! SubCategoryTableViewCell
        let subcategory  = subcategoryList[indexPath.row]
        
         cell.selectionStyle = .none
        cell.subCategoryNameLabel.text = subcategory.sub_cat_name
        if let imageURL = subcategory.sub_cat_image {
            cell.subCategoryImageView.ap_setImage(url: imageURL)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceProviderVC = UIStoryboard(name: Screens.ServiceProviders.name(), bundle: nil).instantiateViewController(withIdentifier: "ServiceProviderViewController") as! ServiceProviderViewController
        let subCategory = self.subcategoryList[indexPath.row]
        serviceProviderVC.title = subCategory.sub_cat_name
        serviceProviderVC.sub_cat_id = subCategory.sub_cat_id
        self.navigationController?.pushViewController(serviceProviderVC, animated: true)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
