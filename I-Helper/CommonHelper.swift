//
//  Constants.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 03/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

import CoreLocation

enum SideMenuOptions: String {
    case showHome, containSideMenu,showJobs, showInvite, showRunningJobs, showJobHistory, showMyAccount, showNotification, showAboutUs, ServiceProviders
    func getSegue() -> String {
        return self.rawValue
    }
}

enum Screens: String {
    case LaunchScreen, Welcome, Login, Main, ServiceProviders, Jobs, InviteCart, RunningJobs, JobHistory, MyAccount, Notification, AboutUs, SideMenu
    func name() -> String {
        return self.rawValue
    }
}
public final class CommonHelper{
    //green 62,234,117
    //blue 129.0,213.0,249.0
    static public let mainColor: UIColor = UIColor(red: 129.0/255.0, green: 213.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    static let textViewBorderColor: CGColor = UIColor(red: 213.0/255.0, green: 213.0/255.0, blue: 213.0/255.0, alpha: 1.0).cgColor
    
    static var userCurrentLocation: CLLocation?
    class func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    class func isValidEmail(emailid:String) -> Bool {
        print("validate emilId: \(emailid)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: emailid)
        return result
    }
    
    static func getDateFromString(dateString: String, dateFormat:String) -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat//"dd-mm-yyyy HH:mm"
        guard let date = formater.date(from: dateString) else{
            return nil
        }
        return date
    }
    
    static func getStringFromDate(date: Date, dateFormat:String) -> String? {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat//"yyyy-mm-dd HH:mm:ss"
        let date = formater.string(from: date)
        return date
    }
    
    static func getDateFromTimeStamp(unixTimeStamp: Double, dateFormat:String) ->String?{
        let date = Date(timeIntervalSince1970: unixTimeStamp/1000)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        //dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormat //Specify your format that you want
        let strdate = dateFormatter.string(from: date)
        return strdate
    }
    
    static func getTimestampFromString(dateString: String, dateFormat:String)-> Double?{
        guard let date = getDateFromString(dateString: dateString, dateFormat: dateFormat)
            else{
                return nil
        }
        let dateStamp:TimeInterval = date.timeIntervalSince1970 * 1000
        return dateStamp
    }
}
