//
//  ViewController.swift
//  MapKitApp
//
//  Created by Gabe Ratcliff on 5/12/16.
//  Copyright © 2016 Gabe Ratcliff. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

class ViewController: UIViewController, MKMapViewDelegate {
 
    @IBOutlet weak var mapView: MKMapView!
    
    var locations = [[String:Double]]()
    //    var didLoad = false
    //FORWARD GEOCODING
    //    func forwardGeocoding(address: String){
    //        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
    //            if error != nil {
    //                print(error)
    //                return
    //            }
    //            if placemarks?.count > 0 {
    //                let placemark = placemarks?[0]
    //                let location = placemark?.location
    //                let coordinate = location?.coordinate
    //                var dict = [ "Latitude": coordinate!.latitude, "Longitude": coordinate!.longitude]
    //                self.didReceiveCoords(dict)
    //                self.didLoad = true
    //                return self.viewDidLoad()
    //            }
    //        })
    ////        print(locations)
    //    }
    func didReceiveCoords(location: NSDictionary){
        locations.append(location as! [String : Double])
        print(locations)
    }
    
    //center on page load
    func centerMapOnLocation(location: MKPointAnnotation, regionRadius: Double){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    //information "button"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.pinColor = .Red
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        return pin
    }

    
    override func viewDidLoad() {
        let model = LocationModel()
        let locations = model.data
        print(locations)
        mapView.delegate = self
        super.viewDidLoad()
        //build annotation pins
        var annotations = [MKPointAnnotation]()
        for dictionary in locations {
            let latitude = CLLocationDegrees(dictionary["Latitude"] as! Double!)
            let longitude = CLLocationDegrees(dictionary["Longitude"] as! Double!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dictionary["name"] as! String!
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(name)"
            annotations.append(annotation)
        }
//        print(annotations)
        mapView.addAnnotations(annotations)
        centerMapOnLocation(annotations[0], regionRadius: 100000.0)
        
    }
    
}

