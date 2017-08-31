//
//  ServiceProviderArea.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 04/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//
/*
 {
 "area_id": "2",
 "provider_id": "2",
 "area_name": "Delhi",
 "lat": "28.7041",
 "lng": "77.1025",
 "is_active": "1",
 "created_date": "2017-07-22 18:52:00"
 }
 */
import Foundation


public final class ServiceProviderArea{
    //MARK: - Constant
    private struct Keys{
        static let area_id = "area_id"
        static let provider_id = "provider_id"
        static let area_name = "area_name"
        static let lat = "lat"
        static let lng = "lng"
        static let is_active = "is_active"
        static let created_date = "created_date"
    }

    //MARK: - Instance Properties
    
    public let area_id: String
    public let provider_id:String
    public let area_name: String
    public let lat:String
    public let lng: String
    public let is_active:String
    public let created_date: String
    
    // MARK: - Object Lifecycle
    public init(area_id:String,provider_id:String, area_name:String, lat:String, lng:String,is_active:String, created_date: String){
        self.area_id = area_id
        self.provider_id = provider_id
        self.area_name = area_name
        self.lat = lat
        self.lng = lng
        self.is_active = is_active
        self.created_date = created_date
    }
    
    public init?(json:[String:Any]){
        
        guard let area_id = json[Keys.area_id] as? String,
            let provider_id = json[Keys.provider_id] as? String,
            let area_name = json[Keys.area_name] as? String,
            let lat = json[Keys.lat] as? String,
            let lng = json[Keys.lng] as? String,
            let is_active = json[Keys.is_active] as? String,
            let created_date = json[Keys.created_date] as? String
            else {
                return nil
        }
        self.area_id = area_id
        self.provider_id = provider_id
        self.area_name = area_name
        self.lat = lat
        self.lng = lng
        self.is_active = is_active
        self.created_date = created_date
    }
    
    // MARK: - Class Constructors
    public class func array(jsonArray:[[String:Any]])->[ServiceProviderArea]{
        var array:[ServiceProviderArea] = []
        for json in jsonArray {
            guard let category = ServiceProviderArea(json:json) else {
                continue
            }
            array.append(category)
        }
        return array
    }
}
