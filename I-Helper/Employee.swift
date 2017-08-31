//
//  Employee.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 07/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation

public final class Employee{
    
    //MARK: - Constants
    private struct Keys{
        static let id = "id"
        static let job_id = "job_id"
        static let provider_id = "provider_id"
        static let name = "name"
        static let mobile = "mobile"
        static let profile_pic = "profile_pic"
        static let status = "status"
        static let created_date = "created_date"
        static let is_individual = "is_individual"
        static let assigned_emp = "assigned_emp"
    }
    
    //MARK: - Instance Properties
    
    public var id:String?
    public var job_id:String?
    public var provider_id:String?
    public var name:String?
    public var mobile:String?
    public var profile_pic:String?
    public var status:String?
    public var created_date:String?
    public var is_individual:String?
    public var assigned_emp:[String:Any]?
    
    //MARK: - Object Lifecycle
    public init(id:String,
        job_id:String,
        provider_id:String,
        name:String,
        mobile:String,
        profile_pic:String,
        status:String,
        created_date:String,
        is_individual:String,
        assigned_emp:[String:Any]){
        self.id = id
        self.job_id = job_id
        self.provider_id = provider_id
        self.name = name
        self.mobile = mobile
        self.profile_pic = profile_pic
        self.status = status
        self.created_date = created_date
        self.is_individual = is_individual
        self.assigned_emp = assigned_emp
    }
    
    public init?(json:[String:Any]){
        
        guard let id = json[Keys.id] as? String?,
            let job_id = json[Keys.job_id] as? String?,
            let provider_id = json[Keys.provider_id] as? String?,
            let name = json[Keys.name] as? String?,
            let mobile = json[Keys.mobile] as? String?,
            let profile_pic = json[Keys.profile_pic] as? String?,
            let status = json[Keys.status] as? String?,
            let created_date = json[Keys.created_date] as? String?,
            let is_individual = json[Keys.is_individual] as? String?
        
            
            else { return nil }
        
        self.id = id
        self.job_id = job_id
        self.provider_id = provider_id
        self.name = name
        self.mobile = mobile
        self.profile_pic = profile_pic
        self.status = status
        self.created_date = created_date
        self.is_individual = is_individual
        
        if let assigned_emp = json[Keys.assigned_emp] as? [String:Any]{
            self.assigned_emp = assigned_emp
        }
        
    }
    
    //MARK: - Class Constructors
    
    public class func array(jsonObject:[[String:Any]])->[Employee]{
        var array:[Employee] = []
        for json in jsonObject {
            guard let employee = Employee(json: json)
                else { continue  }
            
            array.append(employee)
        }
        return array
    }
}
