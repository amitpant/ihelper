//
//  OTPVerficationViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 08/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class OTPVerficationViewController: UIViewController {

    @IBOutlet weak var changeMobileButton: UIButton!
    @IBOutlet weak var otpResendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var oTPTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var seconds = 10
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
       
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        oTPTextField.addDoneButtonToKeyboard(myAction:  #selector(self.oTPTextField.resignFirstResponder))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow , object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: self.view.window)
    }

    func startTimer()  {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](timer) in
            
            guard let strongSelf = self else{return}
            strongSelf.seconds -= 1
            if strongSelf.seconds>=0{
                strongSelf.timerLabel.text = String(format:"00:%02i",strongSelf.seconds) 
                strongSelf.otpResendButton.isEnabled = false
                 strongSelf.changeMobileButton.isEnabled = false
            }
            else{
                strongSelf.timer.invalidate()
                strongSelf.otpResendButton.isEnabled = true
                strongSelf.changeMobileButton.isEnabled = true
                
            }
        })
    }
    @IBAction func otpResendPressed(_ sender: UIButton) {
        startTimer()
    }
    @IBAction func nextPressed(_ sender: Any) {
        guard let submitUserDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "SubmitUserDetailsVC" ) as? SubmitUserDetailsViewController else {
            return
        }
        
        self.navigationController?.pushViewController(submitUserDetailsVC, animated: true)
        
    }
    @IBAction func changeMobileNoPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: Keyboard notification methods
    func keyboardWillShow(notification: Notification)  {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let offset:CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: {
                    () -> Void in
                    self.view.frame.origin.y -= 20
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

extension OTPVerficationViewController:UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 4 && string.characters.count != 0 {
          
            
            return false
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
