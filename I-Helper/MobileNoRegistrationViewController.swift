//
//  MobileNoRegistrationViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 08/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit
//import CCCountrySelector

class MobileNoRegistrationViewController: UIViewController {

    //@IBOutlet weak var selectView: CountrySelectorView!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var countries: [String] = []
   
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        /*selectView.delegate = self;
        if let defCountry =  Locale.current.regionCode {
            selectView.setDefaultCountry(defCountry)
        }else{
            selectView.setDefaultCountry("US")
        }*/
       
        mobileNoTextField.addDoneButtonToKeyboard(myAction:  #selector(self.mobileNoTextField.resignFirstResponder))
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:.UIKeyboardWillShow , object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: self.view.window)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        print()
        guard let mobile = mobileNoTextField.text, mobile.characters.count > 0 else {
            self.showAlertMessage(title: "Error!!", message: "Please enter your mobile number.", isSuccess: false)
            
            return
        }
        if CommonHelper.validate(value: mobile){
            guard let oTPVerficationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerficationVC" ) as? OTPVerficationViewController else {
                return
            }
            
            self.navigationController?.pushViewController(oTPVerficationViewController, animated: true)
            let mobileno = mobile.replacingOccurrences(of: "-", with: "")
            UserDefaults.standard.set(mobileno, forKey: "userMobileNo")
        }
        else{
            self.showAlertMessage(title: "Error!!", message: "Please enter a valid mobile number.", isSuccess: false)
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

extension MobileNoRegistrationViewController:UITextFieldDelegate{
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard let mobileno = textField.text else { return false }
//        
//        if CommonHelper.validate(value: mobileno){
//            textField.resignFirstResponder()
//            self.nextButton.isEnabled = true
//            return true
//        }
//        else{
//            let alertCtrl = UIAlertController(title: "Error!!!", message: "Please enter a valid mobile number.", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//            alertCtrl.addAction(alertAction)
//            self.present(alertCtrl, animated: true, completion: nil)
//            
//        }
//        return false
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 3 && string.characters.count != 0 {
            textField.text = textField.text! + "-"
        }

        else if textField.text?.characters.count == 7 && string.characters.count != 0 {
            textField.text = textField.text! + "-"
        }

        if textField.text?.characters.count == 12 && string.characters.count != 0 {
            return false
        }
        return true
    }
}

/*extension MobileNoRegistrationViewController: CountrySelectorViewDelegate{
    func layoutPickView(_ pickerView: UIPickerView) {
        
        let variableBindings = [ "pickerView": pickerView]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[pickerView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.view.addConstraints(horizontalConstraints)
        
        let bottomConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[pickerView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.view.addConstraints(bottomConstraints)
    }
    
    func showPickInView()->UIView {
        return self.view
    }
    
    func phoneCodeDidChange(_ myPickerView: UIPickerView, phoneCode: String) {
        print(phoneCode)
    }
    
    
    func customPickerView(_ countryData: CountryData) -> UIView {
        
        return DefaulCountryPickView.init(countryData: countryData)
        // hide flag image in DefaulCountryPickView
        //    return DefaulCountryPickView.init(countryData: countryData, isFlagHidden: true)
        //  use custom view if needed
        //  return CustomCountryPickerView.init(countryData: countryData)
    }

}*/
