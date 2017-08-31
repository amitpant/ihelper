//
//  FileComplainVC.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 11/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class FileComplainVC: UIViewController {
    
    @IBOutlet weak var complainTextView: UITextView!{
        didSet{
            complainTextView?.layer.cornerRadius = 8.0
            complainTextView?.layer.borderColor = CommonHelper.textViewBorderColor
            complainTextView?.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var job_id:String?
    var keyboardHeight:CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow , object: self.view.window)
        
        complainTextView.addDoneButtonToKeyboard(myAction:  #selector(self.complainTextView.resignFirstResponder))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        //{"job_id":"1","comment_title":"Test Title",  "comment":"Test"}
        guard let subject = subjectTextField.text, subject.characters.count > 0 else {
            self.showAlertMessage(title: "Error!!", message: "Please enter subject before submit.", isSuccess: false)
            return
        }
        guard let complain = complainTextView.text, complain.characters.count > 0 else {
            self.showAlertMessage(title: "Error!!", message: "Please enter complain before submit.", isSuccess: false)
            return
        }
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        
        if let job_id = job_id  {
            let params = ["job_id":job_id,"comment_title":"\(subject)","comment":"\(complain)"] as [String:Any]
            
            NetworkClient.shared.downloadDataWithAPIName(apiname: "raiseComplaint", params: params, success: {[weak self] (serverresponse) in
                print(serverresponse)
                guard let strongSelf = self else {return}
                
                if let status = serverresponse["status"] as? Bool, status, let message = serverresponse["message"] as? String{
                    DispatchQueue.main.async {
                        strongSelf.showAlertMessage(title: "Message", message: message, isSuccess: true)
                    }
                    
                }
                else if let message = serverresponse["message"] as? String {
                    DispatchQueue.main.async {
                        strongSelf.showAlertMessage(title: "Error!!", message: message, isSuccess: false)
                    }
                }
                
                CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
            }) { (error) in
                print(error)
                CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
            }
        }
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
    
    func keyboardWillShow( notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
}


extension FileComplainVC:UITextViewDelegate{
    
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
