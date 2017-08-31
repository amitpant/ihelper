//
//  ServiceProviderViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class ServiceProviderViewController: UIViewController, UITextFieldDelegate {

    var arrServiceTypes = ["All","Individual","Agenices"]
    var  selectedIndex = 0
    var sub_cat_id:String?
    var serviceProviderList = [ServiceProvider]()
    var selectedProviderIds:[String] = []{
        didSet{
            if selectedProviderIds.count > 0 {
                self.nextBarButton.isEnabled = true
            }else{
                self.nextBarButton.isEnabled = false
            }
        }
    }
    
    // variables to gold current data
    var picker : UIPickerView!
   
    var activeValue = ""
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var serviceTypeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.nextBarButton.isEnabled = false
       /* guard let currentLocation = CommonHelper.userCurrentLocation else { return  }
        let lat = "\(currentLocation.coordinate.latitude)"
        let lng = "\(currentLocation.coordinate.latitude)"*/
        guard let sub_cat_id = sub_cat_id else { return  }
        let params = ["lat":"28.6104655","lng":"77.3544517","employee_type":0,"sub_cat_id":"\(sub_cat_id)"] as [String : Any]//"lat":"28.6104655","lng":"77.3544517"
        print(params)
        self.loadServiceData(params: params)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changeServiceButtonPressed(_ sender: UIButton) {
        //self.setUpServiceTypeView()
        self.pickUpValue(textField: serviceTypeTextField)
    }
    
    func loadServiceData(params: [String : Any])  {
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        NetworkClient.shared.downloadDataWithAPIName(apiname: "getServiceProvider", params: params, success: { [weak self]  (serverResponse) in
            guard let strongSelf = self else{return}
            //print(serverResponse)
            if serverResponse["status"] as! Bool && serverResponse["isarray"] as! Bool{
                if let data = serverResponse["data"] as? [[String:Any]] {
                    DispatchQueue.main.async {
                        
                        strongSelf.serviceProviderList =  ServiceProvider.array(jsonArray: data)
                        strongSelf.tableView.reloadData()
                        
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
    
    /*func setUpServiceTypeView()  {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: self.view.frame.size.width - self.view.frame.size.width/8,height: 100)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - self.view.frame.size.width/8, height: 100))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        vc.view.addSubview(pickerView)
        let serviceOptions = UIAlertController(title: "Select service type", message: "", preferredStyle: UIAlertControllerStyle.alert)
        serviceOptions.setValue(vc, forKey: "contentViewController")
        serviceOptions.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self] (action) in
            guard let strongSelf = self else{return}
            let serviceType = strongSelf.arrServiceTypes[strongSelf.selectedIndex]
           //CustomActivityIndicator().showActivityIndicator(view: strongSelf.view)
            DispatchQueue.main.async {
                 let attrTet = NSMutableAttributedString(string: "\(serviceType)", attributes: nil)
                strongSelf.changeServiceTypeButton.titleLabel?.numberOfLines = 0
                strongSelf.changeServiceTypeButton.setTitle(attrTet.string, for: .normal)
                
                guard let currentLocation = CommonHelper.userCurrentLocation else { return  }
                let lat = "\(currentLocation.coordinate.latitude)"
                let lng = "\(currentLocation.coordinate.latitude)"
                guard let sub_cat_id = strongSelf.sub_cat_id else { return  }
                let params = ["lat":"28.6104655","lng":"77.3544517","employee_type":strongSelf.selectedIndex,"sub_cat_id":"\(sub_cat_id)"] as [String : Any]// "lat":"\(lat)","lng":"\(lng)"
                 print(params)
                strongSelf.loadServiceData(params: params)
            }
            
        }))
        serviceOptions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(serviceOptions, animated: true)
    }
    */
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.pickUpValue(textField: textField)
        
    }
    
    // show picker view
    func pickUpValue(textField: UITextField) {
        
        // create frame and size of picker view
        picker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 100)))
        
        // deletates
        picker.delegate = self
        picker.dataSource = self
        
        // if there is a value in current text field, try to find it existing list
        /*if let currentValue = textField.text {
            
            var row : Int?
            
            // look in correct array
            switch activeTextField {
            case 1:
                row = optionsA.index(of: currentValue)
            case 2:
                row = optionsB.index(of: currentValue)
            default:
                row = nil
            }
            
            // we got it, let's set select it
            if row != nil {
                picker.selectRow(row!, inComponent: 0, animated: true)
            }
        }
        */
        picker.backgroundColor = UIColor.white
        textField.inputView = self.picker
        
        // toolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.barTintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        // buttons for toolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // done
    func doneClick() {
        
        
        if let serviceType = serviceTypeTextField.text, !( serviceType == arrServiceTypes[selectedIndex]) {
            serviceTypeTextField.text = arrServiceTypes[selectedIndex]
           
            /*guard let currentLocation = CommonHelper.userCurrentLocation else { return  }
             let lat = "\(currentLocation.coordinate.latitude)"
             let lng = "\(currentLocation.coordinate.latitude)"*/
             guard let sub_cat_id = self.sub_cat_id else { return  }
            let params = ["lat":"28.6104655","lng":"77.3544517","employee_type":self.selectedIndex,"sub_cat_id":"\(sub_cat_id)"] as [String : Any]// "lat":"\(lat)","lng":"\(lng)"
            print(params)
            self.loadServiceData(params: params)
        }
        
        serviceTypeTextField.resignFirstResponder()
        
    }
    
    // cancel
    func cancelClick() {
        serviceTypeTextField.resignFirstResponder()
    }
    
    @IBAction func nextPressed(_ sender: UIBarButtonItem) {
        
        if let data = UserDefaults.standard.data(forKey: "userObject") as Data?
        {
            guard let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) as? User
                else{
                    return
            }
           guard let jobDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "JobDetailsViewController") as? JobDetailsViewController
            else{
                return
            }
            jobDetailsVC.selectedEmployeeIds = self.selectedProviderIds
            jobDetailsVC.user = user
            jobDetailsVC.title = "Job Details"
            if let title = self.title {
                jobDetailsVC.jobTitle = title
            }
            
            self.navigationController?.pushViewController(jobDetailsVC, animated: true)
            
        }else{
            let alertCtrl = UIAlertController(title: "Error!!!", message: "Please login first", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            
            let loginAction = UIAlertAction(title: "Login", style:.default , handler: { [weak self](action) in
                
                guard let loginVC = UIStoryboard(name: Screens.Login.name(), bundle: nil).instantiateViewController(withIdentifier: "MobileNoRegistrationVC") as? MobileNoRegistrationViewController
                    else{
                        return
                }
                self?.navigationController?.pushViewController(loginVC, animated: true)
                //self?.present(loginVC, animated: true, completion: nil)
            })
            alertCtrl.addAction(loginAction)
            alertCtrl.addAction(cancelAction)
            self.present(alertCtrl, animated: true, completion: nil)
        }
        
    }
    
}

extension ServiceProviderViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrServiceTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.selectedIndex == row {
            pickerView.selectRow(row, inComponent: component, animated: true)
        }
        return arrServiceTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         self.selectedIndex = row
    }
    
}

extension ServiceProviderViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.serviceProviderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceProviderTableViewCell", for: indexPath) as! ServiceProviderTableViewCell
        let serviceProvider = serviceProviderList[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configureCell(serviceProvider: serviceProvider)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let serviceProvider = serviceProviderList[indexPath.row]
        guard let serviceDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceProviderDetailViewController") as? ServiceProviderDetailViewController else { return  }
        serviceDetailVC.serviceProvider = serviceProvider
        self.navigationController?.pushViewController(serviceDetailVC, animated: true)
    }
    
    
}

extension ServiceProviderViewController:ServiceProviderTableViewCellDelegate{
    func selProviderIdToJobList(providerID: String, isselected: Bool) {
        if selectedProviderIds.contains(providerID) {
            if !isselected {
                if let index = self.selectedProviderIds.index(of:providerID) {
                    self.selectedProviderIds.remove(at: index)
                }
            }
        }
        else{
            self.selectedProviderIds.append(providerID)
        }
    }
}
