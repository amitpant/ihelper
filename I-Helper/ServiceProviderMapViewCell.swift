//
//  ServiceProviderMapViewCell.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 09/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit
import MapKit

class ServiceProviderMapViewCell: UITableViewCell,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let mapView = self.mapView
        {
            mapView.delegate = self
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showLocation(location:CLLocation, areaName:String) {
        let orgLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = orgLocation
        dropPin.title = areaName
        mapView!.addAnnotation(dropPin)
        self.mapView?.setRegion(MKCoordinateRegionMakeWithDistance(orgLocation, 500, 500), animated: true)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
