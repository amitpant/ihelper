//
//  User.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 08/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation
// ["profile_pic": http://122.160.42.242/~priya/i_helper/api/, "name": Amit, "email": iOS@maxtra.com, "lng": 0, "mobile": 0, "device_token": , "created_date": 2017-08-08 14:08:28, "user_id": 29, "lat": 0, "device_type": I]

final class User :NSObject,NSCoding{
    //MARK: - Constants
    private struct Keys{
        static let profile_pic = "profile_pic"
        static let name = "name"
        static let email = "email"
        //static let lng = "lng"
        //static let lat = "lat"
        //static let mobile = "mobile"
        static let device_token = "device_token"
        static let created_date = "created_date"
        static let user_id = "user_id"
        
        static let device_type = "device_type"
    }
    
    //MARK: - Instance Properties
    public let profile_pic:String
    public let name:String
    public let email:String
    //public let lng:Int
    //public let lat:Int
    //public let mobile:Int
    public let device_token:String
    public let created_date:String
    public let user_id:String
    public let device_type:String
    //MARK: - Object lifecycle
    public init(profile_pic:String,name:String,email:String,device_token:String,created_date:String,user_id:String,device_type:String){
        self.profile_pic = profile_pic
        self.name = name
        self.email = email
        //self.lng = lng
        //self.lat = lat
        //self.mobile = mobile
        self.device_type = device_type
        self.device_token = device_token
        self.created_date = created_date
        self.user_id = user_id
    }
    
    public init?(json:[String:Any]){
        guard let profile_pic = json[Keys.profile_pic] as? String,
        let name = json[Keys.name] as? String,
        let email = json[Keys.email] as? String,
        //let lng = json[Keys.lng] as? Int,
        //let lat = json[Keys.lat] as? Int,
        //let mobile = json[Keys.mobile] as? Int,
        let device_type = json[Keys.device_type] as? String,
        let device_token = json[Keys.device_token] as? String,
        let created_date = json[Keys.created_date] as? String,
        let user_id = json[Keys.user_id] as? String
            else { return nil }
        
        self.profile_pic = profile_pic
        self.name = name
        self.email = email
        //self.lng = lng
        //self.lat = lat
        //self.mobile = mobile
        self.device_type = device_type
        self.device_token = device_token
        self.created_date = created_date
        self.user_id = user_id
    }
    
    required convenience public init?(coder aDecoder:NSCoder) {
        guard let profile_pic = aDecoder.decodeObject(forKey: "profile_pic") as? String,
            let name = aDecoder.decodeObject(forKey: "name") as? String,
            let email = aDecoder.decodeObject(forKey: "email") as? String,
            let device_type = aDecoder.decodeObject(forKey: "device_type") as? String,
            let device_token = aDecoder.decodeObject(forKey: "device_token") as? String,
            let created_date = aDecoder.decodeObject(forKey: "created_date") as? String,
            let user_id = aDecoder.decodeObject(forKey: "user_id") as? String
            else { return nil }
        
        //let mobile = aDecoder.decodeInteger(forKey:"mobile")
        //let lng = aDecoder.decodeInteger(forKey: "lng")
        //let lat = aDecoder.decodeInteger(forKey: "lat")
        //let user_id = aDecoder.decodeInteger(forKey:  "user_id")
        
        
        self.init(profile_pic: profile_pic, name: name, email: email,  device_token: device_token, created_date: created_date, user_id: user_id, device_type: device_type)
    }
   
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.profile_pic, forKey: "profile_pic")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        //aCoder.encode(self.lng, forKey: "lng")
        //aCoder.encode(self.lat, forKey: "lat")
        //aCoder.encode(self.mobile, forKey: "mobile")
        aCoder.encode(self.device_token, forKey: "device_token")
        aCoder.encode(self.created_date, forKey: "created_date")
        aCoder.encode(self.user_id, forKey: "user_id")
        aCoder.encode(self.device_type, forKey: "device_type")
    }

    //MARK: - Class Constructors
    
    
    class func array(jsonObject:[[String:Any]])->[User]{
        var array:[User] = []
        for json in jsonObject {
            guard let user = User(json: json) else { continue }
            array.append(user)
        }
        return array
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
