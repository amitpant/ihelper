//
//  ServiceProvider.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 04/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//
/*
 
 "provider_id": "2",
 "company_name": "",
 "company_reg_no": "",
 "unique_agency_number": "12346",
 "employee_no": "0",
 "name": "Rahul Gandhi",
 "reg_no": "",
 "mobile": "9999996667",
 "email": "rahul@gmail.com",
 "password": "123456",
 "profile_pic": "http://122.160.42.242/~priya/i_helper/api/profile_images/20170724092108.png",
 "is_individual": "1",
 "is_verified": "1",
 "job_done": "3",
 "rating": "4.5",
 "device_token": "",
 "payment_status": "0",
 "expiry_date": "2017-08-04 14:55:22",
 "package_id": "0",
 "created_date": "2017-07-24 12:02:33",
 "sub_cat_id": "3",
 "area_list": [ area
 
 ]
 */
import Foundation
public final class ServiceProvider{
    
    //MARK: - Constant
    private struct Keys{
        static let provider_id = "provider_id"
        static let company_name = "company_name"
        static let company_reg_no = "company_reg_no"
        static let unique_agency_number = "unique_agency_number"
        static let employee_no = "employee_no"
        static let name = "name"
        static let reg_no = "reg_no"
        static let mobile = "mobile"
        static let email = "email"
        static let password = "password"
        static let profile_pic = "profile_pic"
        static let is_individual = "is_individual"
        static let is_verified = "is_verified"
        static let job_done = "job_done"
        static let rating = "rating"
        static let device_token = "device_token"
        static let payment_status = "payment_status"
        static let expiry_date = "expiry_date"
        
        static let package_id = "package_id"
        static let created_date = "created_date"
        static let sub_cat_id = "sub_cat_id"
        static let area_list = "area_list"
    
    }
    
    //MARK: - Instance Properties
    
    
    
    public let provider_id : String
    public let company_name : String
    public let company_reg_no : String
    public let unique_agency_number : String
    public let employee_no : String
    public let name : String
    public let reg_no : String
    public let mobile : String
    public let email : String
    public let password : String
    public let profile_pic : String
    public let is_individual : String
    public let is_verified : String
    public let job_done : String
    public let rating : String
    public let device_token : String
    public let payment_status : String
    public let expiry_date : String
    
    public let package_id : String
    public let created_date : String
    public let sub_cat_id : String
    public let area_list : [ServiceProviderArea]
    
    // MARK: - Object Lifecycle
    public init(provider_id:String, company_name:String, company_reg_no:String, unique_agency_number:String,employee_no:String, name: String,
                reg_no:String, mobile:String, email:String, password:String,profile_pic:String, is_individual: String,
                is_verified:String, job_done:String, rating:String, device_token:String,payment_status:String, expiry_date: String,
                package_id:String, created_date:String, sub_cat_id:String, area_list:[ServiceProviderArea]){
        self.provider_id = provider_id
        self.company_name = company_name
        self.company_reg_no = company_reg_no
        self.unique_agency_number = unique_agency_number
        self.employee_no = employee_no
        self.name = name
        self.reg_no = reg_no
        self.mobile = mobile
        self.email = email
        self.password = password
        self.profile_pic = profile_pic
        self.is_individual = is_individual
        self.is_verified = is_verified
        self.job_done = job_done
        self.rating = rating
        self.device_token = device_token
        self.payment_status = payment_status
        self.expiry_date = expiry_date
        self.package_id = package_id
        self.created_date = created_date
        self.sub_cat_id = sub_cat_id
        self.area_list = area_list
    }
    
    public init?(json:[String:Any]){
        
        guard let provider_id = json[Keys.provider_id] as? String,
            let company_name = json[Keys.company_name] as? String,
            let company_reg_no = json[Keys.company_reg_no] as? String,
            let unique_agency_number = json[Keys.unique_agency_number] as? String,
            let employee_no = json[Keys.employee_no] as? String,
            let name = json[Keys.name] as? String,
            let mobile = json[Keys.mobile] as? String,
            
        let reg_no = json[Keys.reg_no] as? String,
        let email = json[Keys.email] as? String,
        let password = json[Keys.password] as? String,
        let profile_pic = json[Keys.profile_pic] as? String,
        let is_individual = json[Keys.is_individual] as? String,
        let is_verified = json[Keys.is_verified] as? String,
        let job_done = json[Keys.job_done] as? String,
        
        let rating = json[Keys.rating] as? String,
        let device_token = json[Keys.device_token] as? String,
        let payment_status = json[Keys.payment_status] as? String,
        let expiry_date = json[Keys.expiry_date] as? String,
        let package_id = json[Keys.package_id] as? String,
        let sub_cat_id = json[Keys.sub_cat_id] as? String,
        let created_date = json[Keys.created_date] as? String,
        
        let area_list = json[Keys.area_list] as? [[String:Any]]
            else {
                return nil
        }
        self.provider_id = provider_id
        self.company_name = company_name
        self.company_reg_no = company_reg_no
        self.unique_agency_number = unique_agency_number
        self.employee_no = employee_no
        self.name = name
        self.reg_no = reg_no
        self.mobile = mobile
        self.email = email
        self.password = password
        self.profile_pic = profile_pic
        self.is_individual = is_individual
        self.is_verified = is_verified
        self.job_done = job_done
        self.rating = rating
        self.device_token = device_token
        self.payment_status = payment_status
        self.expiry_date = expiry_date
        self.package_id = package_id
        self.created_date = created_date
        self.sub_cat_id = sub_cat_id
        self.area_list = ServiceProviderArea.array(jsonArray: area_list)
    }
    
    // MARK: - Class Constructors
    public class func array(jsonArray:[[String:Any]])->[ServiceProvider]{
        var array:[ServiceProvider] = []
        for json in jsonArray {
            guard let category = ServiceProvider(json:json) else {
                continue
            }
            array.append(category)
        }
        return array
    }
}
