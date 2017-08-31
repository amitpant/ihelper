//
//  ServiceProviderViewModel.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 09/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

enum ServiceProviderViewModelItemType {
    case serviceprovider
    case serviceprovidermapview
    case employee
    
}

protocol ServiceProviderViewModelItem {
    var type: ServiceProviderViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class ServiceProviderViewModel: NSObject {
    var items = [ServiceProviderViewModelItem]()
    //var serviceProvider:ServiceProvider?
    
     init( serviceProvider:ServiceProvider?) {
        super.init()
        if let serviceProvider = serviceProvider {
            //self.serviceProvider = serviceProvider
            let name = serviceProvider.name
            let pictureUrl = serviceProvider.profile_pic
            let jobDone = serviceProvider.job_done
            let rating = serviceProvider.rating
            let agenciesItem = ServiceProviderViewModelAgenciesItem(name: name, pictureUrl: pictureUrl,jobDone: jobDone,rating: rating)
            items.append(agenciesItem)
            
            
          
            if !(serviceProvider.area_list.isEmpty) {
                let ServiceAreaItem = ServiceProviderViewModelServiceAreaItem(serviceAreaList: serviceProvider.area_list)
                items.append(ServiceAreaItem)
            }
        }
        
        
      /*  let attributes = profile.profileAttributes
        if !attributes.isEmpty {
            let attributesItem = ProfileViewModeAttributeItem(attributes: attributes)
            items.append(attributesItem)
        }
        
        let friends = profile.friends
        if !profile.friends.isEmpty {
            let friendsItem = ProfileViewModeFriendsItem(friends: friends)
            items.append(friendsItem)
        }*/
    }
}

extension ServiceProviderViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .serviceprovider:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ServiceProviderDetailsCell.identifier, for: indexPath) as? ServiceProviderDetailsCell {
                if let item = item as? ServiceProviderViewModelAgenciesItem {
                    cell.item = item
                }
                cell.selectionStyle = .none
                return cell
            }
        case .serviceprovidermapview:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ServiceProviderMapViewCell.identifier, for: indexPath) as? ServiceProviderMapViewCell {
                if let item = item as? ServiceProviderViewModelServiceAreaItem {
                    for area in item.serviceAreaList {
                        guard let lat = Double(area.lat), let lng = Double(area.lng) else {
                            continue
                        }
                         let location = CLLocation(latitude: lat, longitude: lng)
                        
                        cell.showLocation(location: location, areaName: area.area_name)
                        
                    }
                    
                }
               cell.selectionStyle = .none
                return cell
            }
       
        case .employee:
            if let item = item as? ServiceProviderViewModelEmployessItem, let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeDetailCell.identifier, for: indexPath) as? EmployeeDetailCell {
//                let friend = item.friends[indexPath.row]
//                cell.item = friend
                return cell
            }
       
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}


class ServiceProviderViewModelAgenciesItem: ServiceProviderViewModelItem {
    var type: ServiceProviderViewModelItemType {
        return .serviceprovider
    }
    
    var sectionTitle: String {
        return "Main Info"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var name: String
    var pictureUrl: String
    var jobDone: String
    var rating: String
    init(name: String, pictureUrl: String,jobDone: String,rating: String) {
        self.name = name
        self.pictureUrl = pictureUrl
        self.jobDone = jobDone
        self.rating = rating
    }
}

class ServiceProviderViewModelServiceAreaItem: ServiceProviderViewModelItem {
    var type: ServiceProviderViewModelItemType {
        return .serviceprovidermapview
    }
    
    var sectionTitle: String {
        return "Map Info"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var serviceAreaList: [ServiceProviderArea]
    
    
    init(serviceAreaList: [ServiceProviderArea]) {
        self.serviceAreaList = serviceAreaList
    }
}

class ServiceProviderViewModelEmployessItem: ServiceProviderViewModelItem {
    var type: ServiceProviderViewModelItemType {
        return .employee
    }
    
    var sectionTitle: String {
        return "Employees"
    }
    
    var rowCount: Int {
        return employees.count
    }
    
    var employees: [Employee]
    
    init(employees: [Employee]) {
        self.employees = employees
    }
}


