//
//  ViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 31/07/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

import CoreLocation
import GooglePlaces

protocol ViewControllerDelegate: class {
    func mainVCMenuButtonTapped(_ controller: ViewController)
}

class ViewController: UIViewController {
    
    // MARK: - Instance Properties
    internal var categories: [Category] = []
    weak var delegate: ViewControllerDelegate?
    var selectedIndex :Int?
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var geocoder: CLGeocoder? = nil
    
  
    
    @IBAction func changeLocation(_ sender: Any) {
        changeUserLocation()
    
    }
    
    func changeUserLocation() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let locTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.changeUserLocation))
        titleLabel.addGestureRecognizer(locTapGesture)
//        categoryTableView.rowHeight = UITableViewAutomaticDimension
//        categoryTableView.estimatedRowHeight = 200
//        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
        NetworkClient.shared.downloadDataWithAPIName(apiname: "getCategory", params: nil, success: { [weak self]  (serverResponse) in
            // print(serverResponse)
            guard let strongSelf = self else{return}
            if serverResponse["status"] as! Bool && serverResponse["isarray"] as! Bool{
                if let data = serverResponse["data"] as? [[String:Any]] {
                    DispatchQueue.main.async {
                        strongSelf.categories =  Category.array(jsonArray: data)
                        strongSelf.categoryTableView.reloadData()
                        
                    }
                }
            }else{
                print(serverResponse["message"] as! String)
            }
            CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
            
        }) { (error) in
            print(error)
            CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
        }
    }
    
    }

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        let category = categories[indexPath.section]
        cell.viewAllButton.tag = indexPath.section
        cell.configureCell(category)
        //cell.
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchTVC = segue.destination as? SearchCategoryTableViewController {
            searchTVC.categories = self.categories
        }
    }
}


extension ViewController: CategoryTableViewCellDelegate{
    func viewAllButtonPressed(index: Int) {
        
        guard let subCategoryView = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryTableViewController") as? SubCategoryTableViewController else {
            return
        }
        
        let category = categories[index]
        subCategoryView.setUpView(title: category.category_name, subcategoryList: category.sub_category)
        self.navigationController?.pushViewController(subCategoryView, animated: true)
    }
    
    func subCategoryCellPressed(subCategory: SubCategory) {
        guard let serviceProviderVC = UIStoryboard(name: Screens.ServiceProviders.name(), bundle: nil).instantiateViewController(withIdentifier: "ServiceProviderViewController") as? ServiceProviderViewController else { return  }
        
       
        serviceProviderVC.title = subCategory.sub_cat_name
        serviceProviderVC.sub_cat_id = subCategory.sub_cat_id
        self.navigationController?.pushViewController(serviceProviderVC, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
  
 
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.first
            if geocoder == nil {
                geocoder = CLGeocoder()
            }
            CommonHelper.userCurrentLocation = currentLocation
            //let location = CLLocation(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
            geocoder?.reverseGeocodeLocation(currentLocation!) {
                [weak self] placemarks, error in
                if (placemarks?.count)! > 0 {
                    let placemark = placemarks?.first!
                    //let streetNumber = placemark?.subThoroughfare
                    //let street = placemark?.thoroughfare
                    let city = placemark?.locality
                    let state = placemark?.administrativeArea
                    let locationString = "\(city!),\n \(state!)"
                    self?.titleLabel.text = locationString
                    UserDefaults.standard.setValue(locationString, forKey: "userCurrentLocation")
                    //hide activityIndicatorView
                   // self?.customActivityIndicatory((self?.view)!, startAnimate: false)
                }
            }
            
        }
    }
   
}


extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        
        //if let placeAddress = place.formattedAddress {
        
        
        guard let formattedAddress = place.formattedAddress else{return}
        let arrAddress = formattedAddress.components(separatedBy: ",")
        
            titleLabel.text = "\(arrAddress[0]),\n \(arrAddress[1])"
        guard let address = place.formattedAddress else
        {
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            // Use your location
            print("change location: \(location)")
          
        }
            dismiss(animated: true, completion: nil)
       // }
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}




