//
//  MyAccountTableViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 17/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit
import Alamofire
import Photos

class MyAccountTableViewController: UITableViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            profileImageView?.contentMode = .scaleAspectFill
            profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
            profileImageView?.clipsToBounds = true
            profileImageView?.backgroundColor = UIColor.gray
        }
    }
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var  imageTapGesture:UITapGestureRecognizer?
    var user_id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.title = "Edit"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        // The following property allows you to select cells while in editing mode
        self.tableView.allowsSelectionDuringEditing = true
        setUpUserDetails()
        changeTextFieldState(isEditing: false)
        imageTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.profileImageTapGesture))
        mobileTextField.addDoneButtonToKeyboard(myAction:  #selector(mobileTextField.resignFirstResponder))
        nameTextField.addDoneButtonToKeyboard(myAction:  #selector(nameTextField.resignFirstResponder))
        emailTextField.addDoneButtonToKeyboard(myAction:  #selector(emailTextField.resignFirstResponder))
    }
    
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if self.isEditing {
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.profileImageView.addGestureRecognizer(imageTapGesture!)
            changeTextFieldState(isEditing: true)
            nameTextField.becomeFirstResponder()
        }
        else{
            
            guard let name = nameTextField.text, name.characters.count > 0  else {
                self.isEditing  = true
                showAlertMessage(title: "Error!!", message: "Please enter a valid name.", isSuccess: false)
                return
            }
            
            guard let mobile = mobileTextField.text, mobile.characters.count == 10  else {
                self.isEditing  = true
                showAlertMessage(title: "Error!!", message: "Please enter a vaild mobile no.", isSuccess: false)
                return
            }
            
            guard let email = emailTextField.text, CommonHelper.isValidEmail(emailid: email)  else {
                self.isEditing  = true
                showAlertMessage(title: "Error!!", message: "Please enter a vaild email id.", isSuccess: false)
                return
            }
            
            guard let user_id = user_id else {
                self.isEditing  = true
                return
            }
            
            CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
            self.updateUserInfo(user_id: user_id, name: name, email: email, completionHandler: { [unowned self](serverResponse) -> Void in
                
                if let response = serverResponse ,
                    let status = response["status"] as? String,
                    let message = response["message"] as? String
                {
                    var title = "Message"
                    var isStatus = true
                    if status == "1"{
                        if let data = response["data"] as? [String:Any], let userObject = User(json: data){
                            let userData  = NSKeyedArchiver.archivedData(withRootObject: userObject)
                            UserDefaults.standard.set(userData, forKey: "userObject")
                        }
                        
                    }
                    else{
                        title = "Error!!"
                        isStatus = false
                    }
                    self.showAlertMessage(title: title, message: message, isSuccess: isStatus)
                    
                }
                else{
                    self.showAlertMessage(title: "Error!!", message: "Something went wrong please try again", isSuccess: false)
                    
                }
                
                DispatchQueue.main.async {
                    if !self.isEditing {
                        self.profileImageView.removeGestureRecognizer(self.imageTapGesture!)
                        self.navigationItem.rightBarButtonItem?.title = "Edit"
                        self.changeTextFieldState(isEditing: false)
                        
                    }
                }
                CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
            })
            
            
        }
    }
    
    // The following two functions remove the red minus sign
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func setUpUserDetails()  {
        if let data = UserDefaults.standard.data(forKey: "userObject") {
            guard let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) as? User
                else{
                    return
            }
            guard let mobileNo = UserDefaults.standard.string(forKey: "userMobileNo")  else { return  }
            
            self.user_id = user.user_id
            nameTextField.text  = user.name
            mobileTextField.text = mobileNo
            emailTextField.text = user.email
            
            if let imageURL = URL( string : user.profile_pic ) {
                profileImageView.ap_setImage(url: imageURL)
            }
        }
    }
    
    
    func updateUserInfo(user_id:String,name:String,email:String, completionHandler:@escaping ([String:Any]?)->Void)  {
        // User "authentication":
        let parameters = ["user_id":"\(user_id)", "email":"\(email)","name":"\(name)"]
        
        
        guard let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 1.0) else { return }
        
        NetworkClient.shared.uploadImage(apiname: "updateUser", params: parameters, imageData: imageData, success: { (response) in
            //if let response = response  {
            print(response)
            completionHandler(response)
            //}
        }, failure: { (error) in
            print(error)
            completionHandler(nil)
        })
        /*let url = "http://122.160.42.242/~priya/i_helper/api/customer/updateUser"
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "image", fileName: "test.jpg", mimeType: "image/jpeg")
           // multipartFormData.append(imageData!, withName: "image", mimeType: "image/jpeg")
            for (key,val) in parameters{
                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: url, encodingCompletion: { (encodingResult) in
            switch encodingResult{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let jsonResponse = response.result.value as? [String: Any] {
                        print(jsonResponse)
                        completionHandler(jsonResponse)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(nil)
            }
        })*/
        
    }
    
    func changeTextFieldState(isEditing:Bool)  {
        mobileTextField.isUserInteractionEnabled = isEditing
        nameTextField.isUserInteractionEnabled = isEditing
        emailTextField.isUserInteractionEnabled = isEditing
        profileImageView.isUserInteractionEnabled = isEditing
    }
    
    func showAlertMessage(title: String, message:String, isSuccess:Bool)  {
        let alertCtrl = UIAlertController(title:title , message: message, preferredStyle: .alert)
        var alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        if isSuccess {
            alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self](action) in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
        alertCtrl.addAction(alertAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    func profileImageTapGesture(_ sender: UITapGestureRecognizer) {
        
        let actionCtrl = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { [weak self](action) in
            self?.openImageController(isFromCamera: true)
        }
        actionCtrl.addAction(actionCamera)
        let actionGallery = UIAlertAction(title: "Gallery", style: .default) { [weak self](action) in
            self?.openImageController(isFromCamera: false)
        }
        actionCtrl.addAction(actionGallery)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionCtrl.addAction(actionCancel)
        
        present(actionCtrl, animated: true, completion: nil)
    }
    
    
    func openImageController(isFromCamera:Bool)  {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (isFromCamera) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
}


// MARK: Image Picker Delegate
extension MyAccountTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        self.profileImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
}
