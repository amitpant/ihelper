//
//  SubCategory.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 01/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//


/*
 
 "sub_cat_id": "1",
 "sub_cat_name": "Assembling Furniture",
 "sub_cat_image": "http://www.emergencyplumbinglosangelesca.com/wp-content/uploads/2013/08/Emergency-Plumbing-Service.jpg",
 "category_id": "1"
 */
import Foundation

public final class SubCategory{
    
    // MARK: - Constants
    private struct Keys{
        static let sub_cat_id = "sub_cat_id"
        static let sub_cat_name = "sub_cat_name"
        static let sub_cat_image = "sub_cat_image"
        static let category_id = "category_id"
    }
    
    // MARK: - Instance Properties
    public let sub_cat_id:String
    public let sub_cat_name:String
    public let sub_cat_image:URL?
    public let category_id:String
    
    //MARK: - Object Lifecycle
    public init( sub_cat_id:String, sub_cat_name:String, sub_cat_image:URL?, category_id:String){
        self.category_id = category_id
        self.sub_cat_id = sub_cat_id
        self.sub_cat_name = sub_cat_name
        self.sub_cat_image = sub_cat_image
    }
    
    
    public init?( json:[String:Any]){
        
        guard let category_id = json[Keys.category_id] as? String,
            let sub_cat_id = json[Keys.sub_cat_id] as? String,
            let sub_cat_name = json[Keys.sub_cat_name] as? String,
            let sub_cat_image = json[Keys.sub_cat_image] as? String
            else {
                return nil
        }
        self.category_id = category_id
        self.sub_cat_id = sub_cat_id
        self.sub_cat_name = sub_cat_name
        let imageURL = URL(string: sub_cat_image)
        self.sub_cat_image = imageURL
    }
    
    
    // MARK: - Class Constructors
    public class func array(jsonArray:[[String:Any]])->[SubCategory]{
        var array:[SubCategory] = []
        for json in jsonArray {
            guard let subcategory = SubCategory(json: json) else {
                continue
            }
            array.append(subcategory)
        }
        return array
    }
}
