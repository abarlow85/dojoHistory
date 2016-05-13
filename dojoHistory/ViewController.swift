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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
 
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var pointsOfInterst = [[String:Double]]()

    
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
    ////        print(pointsOfInterst)
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = LocationModel()
        let pointsOfInterst = model.data
        mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        //build annotation pins
        var annotations = [MKPointAnnotation]()
        for dictionary in pointsOfInterst {
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
        
    }

    func didReceiveCoords(location: NSDictionary){
        pointsOfInterst.append(location as! [String : Double])
        print(pointsOfInterst)
    }
    
//    //information "button"
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let reuseIdentifier = "pin"
//        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
//        if pin == nil {
//            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//            pin!.pinColor = .Red
//            pin!.canShowCallout = true
//            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
//        } else {
//            pin!.annotation = annotation
//        }
//        return pin
//    }
    //Find users locations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    

}

