//
//  UserFeedbackVC.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 11/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class UserFeedbackVC: UIViewController {

    @IBOutlet weak var empProfileImageView: UIImageView!{
        didSet{
            empProfileImageView?.layer.cornerRadius = 8.0
            empProfileImageView?.contentMode = .scaleAspectFill
            empProfileImageView?.backgroundColor = .gray
            empProfileImageView?.clipsToBounds = true
        }
    }
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var commentTextView: UITextView!{
        didSet{
            commentTextView?.layer.cornerRadius = 8.0
            commentTextView?.layer.borderColor = CommonHelper.textViewBorderColor
            commentTextView?.layer.borderWidth =  1.0
        }
    }
    @IBOutlet weak var submitButton: UIButton!
    
    
    var job_id:String?
    var provider_id:String?
    var empProfilePic:String?{
        didSet{
            if let empProfilePic = empProfilePic, let imageURL = URL(string: empProfilePic) {
                self.empProfileImageView.ap_setImage(url: imageURL)
            }
        }
    }
    
    var keyboardHeight:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow , object: self.view.window)
        
        commentTextView.addDoneButtonToKeyboard(myAction:  #selector(self.commentTextView.resignFirstResponder))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        //{"job_id":"1","provider_id":"4", "rating":"5", "comment":"Test"}
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        if let comment = commentTextView.text, comment.characters.count>0 {
            if let job_id = job_id, let provider_id = provider_id  {
                let params = ["job_id":job_id,"provider_id":provider_id, "rating":"\(ratingControl.rating)", "comment":comment] as [String:Any]
                NetworkClient.shared.downloadDataWithAPIName(apiname: "feedback", params: params, success: {[weak self] (serverresponse) in
                    print(serverresponse)
                    guard let strongSelf = self else {return}
                    if let status = serverresponse["status"] as? Bool, status{
                        strongSelf.showAlertMessage(title: "Message", message: "Feedback posted successfully thanks.", isSuccess: true)
                    }
                    else if let message = serverresponse["message"] as? String {
                        strongSelf.showAlertMessage(title: "Error!!", message: message, isSuccess: false)
                    }
                    
                    CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
                }) { (error) in
                    print(error)
                    CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
                }
                
            }
            
        }
        else{
            showAlertMessage(title: "Error!", message: "Enter comment before submit", isSuccess: false)
        }
        
    }
    
    func showAlertMessage(title: String, message:String, isSuccess:Bool)  {
        let alertCtrl = UIAlertController(title:title , message: message, preferredStyle: .alert)
        var alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        if isSuccess {
            alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self](action) in
                self?.dismiss(animated: true, completion: nil)
                self?.navigationController?.popToRootViewController(animated: true)
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

extension UserFeedbackVC:UITextViewDelegate{
    
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
