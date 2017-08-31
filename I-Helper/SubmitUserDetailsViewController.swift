//
//  SubmitUserDetailsViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 08/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class SubmitUserDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailIdTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow , object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: self.view.window)
        
        nameTextField.addDoneButtonToKeyboard(myAction:  #selector(self.nameTextField.resignFirstResponder))
        emailIdTextField.addDoneButtonToKeyboard(myAction:  #selector(self.emailIdTextField.resignFirstResponder))
    }
    
    
 
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        if let name = nameTextField.text, let emailid = emailIdTextField.text{
            
            if name.characters.count > 2 {
                if  CommonHelper.isValidEmail(emailid: emailid)  {
                   guard let mobileNo = UserDefaults.standard.string(forKey: "userMobileNo")  else { return  }
                    CustomActivityIndicator.shared
                        .showActivityIndicator(view: self.view)
                    
                    
                    let params = ["device_token":"","device_type":"I","email":"\(emailid)","mobile":"\( mobileNo)","name":"\(name)"]
                    print(params)
                    NetworkClient.shared.downloadDataWithAPIName(apiname: "signup", params: params, success: { [weak self]  (serverResponse) in
                        print(serverResponse)
                        if serverResponse["status"] as! Bool && serverResponse["isarray"] as! Bool{
                            if let data = serverResponse["data"] as? [String:Any] {
                                DispatchQueue.main.async {
                                    guard let strongSelf = self else{return}
                                    if let userObject = User(json: data){
                                        let userData  = NSKeyedArchiver.archivedData(withRootObject: userObject)
                                        UserDefaults.standard.set(userData, forKey: "userObject")
                                        CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
                                        
                                        guard let mainView = UIStoryboard(name: Screens.SideMenu.name(), bundle: nil).instantiateInitialViewController() as? CustomSideMenuViewController
                                            else{
                                                return
                                        }
                                        UserDefaults.standard.set(true, forKey: "isNotFirstTime_ihelper")
                                        UIApplication.shared.keyWindow?.rootViewController = mainView
                                    }
                                }
                            }
                        }else{
                            print(serverResponse["message"] as! String)
                        }
                        
                    }) { (error) in
                        print(error)
                    }
                }
                else{
                    showAlertMessage(message: "Please enter a vaild email address")
                }
                
            }
            else{
                showAlertMessage(message: "Please enter a vaild name")
            }
        }
    }
    
    func showAlertMessage(message:String)  {
        let alertCtrl = UIAlertController(title: "Error!!!", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertCtrl.addAction(alertAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    /*func SetUpSideMenuController()  {
        let newWindow = UIWindow(frame: window!.bounds)
        newWindow.rootViewController = UIStoryboard(name: "SideMenu", bundle: nil).instantiateInitialViewController()
        newWindow.makeKeyAndVisible()
        newWindow.alpha = 0.0
        
        UIView.animate(withDuration: 0.33, animations: {
            newWindow.alpha = 1.0
            
        }, completion: { _ in
            self.window = newWindow
        })
    }*/
    // MARK: Keyboard notification methods
    func keyboardWillShow(notification: Notification)  {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let offset:CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: {
                    () -> Void in
                    self.view.frame.origin.y -= 60
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
}

extension SubmitUserDetailsViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
