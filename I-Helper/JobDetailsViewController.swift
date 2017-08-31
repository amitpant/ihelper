//
//  JobDetailsViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 08/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit
import SideMenuController

protocol JobDetailsViewControllerDelegate:class {
    func navToRunningJobs()
}

class JobDetailsViewController: UIViewController {
    
   
    //MARK: - Delegate
    weak var delegate:JobDetailsViewControllerDelegate?
   
    //MARK: - Instance Properties
    var user:User?
    var selectedEmployeeIds:[String] = []
    var jobTitle: String?
    var datePicker : UIDatePicker!
    var keyboardHeight:CGFloat!
    
    
    //MARK: - Define identifier
    let notificationName = Notification.Name("SetMenuIndex")
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var jobDateTimeTextField: UITextField!
    @IBOutlet weak var jobDescriptionTextView: UITextView!{
        didSet{
            jobDescriptionTextView.layer.borderColor = CommonHelper.textViewBorderColor
            jobDescriptionTextView.layer.borderWidth = 1.0
            jobDescriptionTextView.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.layer.cornerRadius = 4.0
        }
    }
    
    //MARK: - View Object lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.showInviteCart), name: notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow , object: self.view.window)
        
        jobDescriptionTextView.addDoneButtonToKeyboard(myAction:  #selector(self.jobDescriptionTextView.resignFirstResponder))
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: self.view.window)
        
    }
   
    deinit {
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func checkBoxPressed(_ sender: Any) {
        checkBoxButton.isSelected = !checkBoxButton.isSelected;
        if checkBoxButton.isSelected {
            jobDateTimeTextField.isEnabled = false
            
        }
        else{
            jobDateTimeTextField.isEnabled = true
        }
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        self.validate()
        
    }
    
    
    //MARK: - Instance Functions
    func showInviteCart(){
        sideMenuController?.performSegue(withIdentifier: SideMenuOptions.showJobs.getSegue(), sender: nil)
    }
    
    func showAlertMessage(title: String, message:String, isSuccess:Bool)  {
        let alertCtrl = UIAlertController(title:title , message: message, preferredStyle: .alert)
        var alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        if isSuccess {
             alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self](action) in
                self?.dismiss(animated: true, completion: nil)
                if let notificationName = self?.notificationName{
                    // Navigate to Invite Cart
                    NotificationCenter.default.post(name: notificationName, object: nil)
                }
            })
        }
        alertCtrl.addAction(alertAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    func postUserJob(params: [String: Any]){
        
        NetworkClient.shared.downloadDataWithAPIName(apiname: "sendInvitations", params: params, success: { [weak self](serverResponse) in
            print(serverResponse)
            guard let strongSelf = self else{return}
            if let status = serverResponse["status"] as? Bool, status, let isarray = serverResponse["isarray"] as? Bool, isarray{
                
                DispatchQueue.main.async {
                    strongSelf.showAlertMessage(title: "Message", message: "Job posted successfully.\n Thanks ", isSuccess: true)
                }
                
            }else{
                print(serverResponse["message"] as! String)
                if let message = serverResponse["message"] as? String{
                    strongSelf.showAlertMessage(title: "Error!!!", message: message, isSuccess: false)
                }
            }
            CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
            
            }, failure: { (error) in
                print(error)
                CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
        })
    }
    
    
    func validate(){
        guard let description = jobDescriptionTextView.text, description.characters.count > 0 else {
            self.showAlertMessage(title: "Error!!", message: "Need job description before posting job.", isSuccess: false)
            return
        }
        
        let is_immediate = self.checkBoxButton.isSelected ? "1" : "0"
        var schedule_date = ""
        //later
        if !self.checkBoxButton.isSelected {
            guard let jobdatetime = jobDateTimeTextField.text, jobdatetime.characters.count>0, let dateTimeStamp = CommonHelper.getTimestampFromString(dateString: jobdatetime, dateFormat: "dd-MMM-yyyy, h:mm a")  else{
                self.showAlertMessage(title: "Error!!", message: "Invalid date", isSuccess: false)
                return
            }
            schedule_date = "\(dateTimeStamp)"
            //print(CommonHelper.getDateFromTimeStamp(unixTimeStamp: dateTimeStamp, dateFormat: "dd-MMM-yyyy, h:mm a")!)
        }
            //immediate
        else{
            self.showAlertMessage(title: "Error!!", message: "Select Immediate option or set a valid date before posting job.", isSuccess: false)
            return
        }
        if let user = user, let title = jobTitle  {
            let emp_ids = selectedEmployeeIds.joined(separator: ",")
            let params = ["user_id":"\(user.user_id)","emp_ids":"\(emp_ids)","title":"\(title)","description":"\(description)", "is_immediate":"\(is_immediate)" , "schedule_date":"\(schedule_date)"] as [String:Any]
            self.postUserJob(params: params)
        }

    }
    
    // MARK: Keyboard notification methods
    /*func keyboardWillShow(notification: Notification)  {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let offset:CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: {
                    () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height/2
                })
            }
        }
        else{
            UIView.animate(withDuration: 0.1, animations: {
                ()-> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func keyboardWillHide(notification: Notification)  {
        self.view.frame.origin.y = 0
    }
    */
    func keyboardWillShow( notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
}


extension JobDetailsViewController:UITextFieldDelegate,UITextViewDelegate{
    //MARK:- textFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.jobDateTimeTextField)
        
    }
    //MARK:- Function of datePicker
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(JobDetailsViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(JobDetailsViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // MARK:- Button Done and Cancel
    func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .short
        jobDateTimeTextField.text = dateFormatter1.string(from: datePicker.date)
        jobDateTimeTextField.resignFirstResponder()
    }
    
    func cancelClick() {
        jobDateTimeTextField.resignFirstResponder()
    }
    
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextField(textView, moveDistance: -keyboardHeight + textView.frame.size.height, up: true)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
         moveTextField(textView, moveDistance: -keyboardHeight + textView.frame.size.height, up: false)
    }
    
    
    
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextView, moveDistance: CGFloat, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = up ? moveDistance : -moveDistance
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

}


