//
//  Job.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 07/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation

public final class Job{
    //MARK: - Constants
    private struct Keys{
        static let job_id = "job_id"
        static let user_id = "user_id"
        static let title = "title"
        static let description = "description"
        static let provider_id = "provider_id"
        static let agency_emp_id = "agency_emp_id"
        static let status = "status"
        static let amount = "amount"
        static let is_immediate = "is_immediate"
        static let schedule_date = "schedule_date"
        static let rating = "rating"
        static let comment = "comment"
        static let emp_list = "emp_list"
        static let employee = "employee"
    }
    
    //MARK: - Instance Properties
    public let job_id:String
    public let user_id:String
    public let title:String
    public let description:String
    public let provider_id:String
    public let agency_emp_id:String
    public let status:String
    public let amount:String
    public let is_immediate:String
    public let schedule_date:String
    public var rating:String?
    public var comment:String?
    public var emp_list:[Employee]?
    public var employee:Employee?
    
    //MARK: - Object LifeCycles
    public init(    job_id:String,
    user_id:String,
    title:String,
    description:String,
    provider_id:String,
    agency_emp_id:String,
    status:String,
    amount:String,
    is_immediate:String,
    schedule_date:String,
    rating:String,
    comment:String,
    emp_list:[Employee],
    employee:Employee){
        self.job_id = job_id
        self.user_id = user_id
        self.title = title
        self.description = description
        self.provider_id = provider_id
        self.agency_emp_id = agency_emp_id
        self.status = status
        self.amount = amount
        self.is_immediate = is_immediate
        self.schedule_date = schedule_date
        self.rating = rating
        self.comment = comment
        self.emp_list = emp_list
        self.employee = employee
    }
    
    public init?(json:[String:Any]){
        
        guard let job_id = json[Keys.job_id] as? String,
            let user_id = json[Keys.user_id] as? String,
            let title = json[Keys.title] as? String,
            let description = json[Keys.description] as? String,
            let provider_id = json[Keys.provider_id] as? String,
            let agency_emp_id = json[Keys.agency_emp_id] as? String,
            let status = json[Keys.status] as? String,
            let amount = json[Keys.amount] as? String,
            let is_immediate = json[Keys.is_immediate] as? String,
            let schedule_date = json[Keys.schedule_date] as? String
        
        
            else { return nil }
        
        self.job_id = job_id
        self.user_id = user_id
        self.title = title
        self.description = description
        self.provider_id = provider_id
        self.agency_emp_id = agency_emp_id
        self.status = status
        self.amount = amount
        self.is_immediate = is_immediate
        self.schedule_date = schedule_date
        if let rating = json[Keys.rating] as? String{
            self.rating = rating
        }
        if let comment = json[Keys.comment] as? String{
            self.comment = comment
        }
        
        
      
        if let emp_listJson = json[Keys.emp_list] as? [[String:Any]] {
            self.emp_list =  Employee.array(jsonObject: emp_listJson)
        }
        else if let emp_Json = json[Keys.employee] as? [String:Any], let employee = Employee(json: emp_Json){
            self.employee = employee
        }
    }
    
    //MARK: - Class Constructors
    public class func array(jsonObject:[[String:Any]])->[Job]{
        var array:[Job] = []
        for json in jsonObject {
            guard let job = Job(json:json) else { continue }
            array.append(job)
        }
        return array
    }
    
}
