//
//  Category.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 01/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//


/*"category_id": "1",
 "category_name": "Handiman",
 "category_image": "http://www.purplemango.in/wp-content/uploads/2013/05/Purplemango_Handiman_Identity_011.jpg",
 "sub_category":[]*/
import Foundation

public final class Category{
    
    // MARK: - Constants
    private struct Keys{
        static let category_id = "category_id"
        static let category_name = "category_name"
        static let category_image = "category_image"
        static let sub_category = "sub_category"
    }
    
    // MARK: - Instance Properties
    public let category_id: String
    public let category_name: String
    public let category_image: URL?
    public let sub_category : [SubCategory]
    
    // MARK: - Object Lifecycle
    public init(category_id:String,category_name:String, category_image:URL?, sub_category:[SubCategory]){
        self.category_id = category_id
        self.category_name = category_name
        self.category_image = category_image
        self.sub_category = sub_category
    }
    
    public init?(json:[String:Any]){
        
        guard let category_id = json[Keys.category_id] as? String,
            let category_name = json[Keys.category_name] as? String,
            let category_image = json[Keys.category_image] as? String,
            let sub_category = json[Keys.sub_category] as? [[String:Any]]
            else {
                return nil
        }
        self.category_id = category_id
        self.category_name = category_name
        let imageURL = URL(string: category_image)
        self.category_image = imageURL
        self.sub_category = SubCategory.array(jsonArray: sub_category)
    }
    
    // MARK: - Class Constructors
    public class func array(jsonArray:[[String:Any]])->[Category]{
        var array:[Category] = []
        for json in jsonArray {
            guard let category = Category(json:json) else {
                continue
            }
            array.append(category)
        }
        return array
    }
}
