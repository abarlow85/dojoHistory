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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, BackButtonDelegate {
 
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var annotations = [MKPointAnnotation]()

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
        let pointsOfInterst = model.data as NSArray
        mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        
        //build annotation pins
//        var annotations = [MKPointAnnotation]()
        for dictionary in pointsOfInterst {
            let latitude = CLLocationDegrees(dictionary["Latitude"] as! Double!)
            let longitude = CLLocationDegrees(dictionary["Longitude"] as! Double!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dictionary["name"] as! String!
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(name)"
            annotation.subtitle = ""
            annotations.append(annotation)
        }
                print(annotations.count)
        mapView.addAnnotations(annotations)
        
    }
//
//    func didReceiveCoords(location: NSDictionary){
//        pointsOfInterst.append(location as! [String : Double])
//        print(pointsOfInterst)
//    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegueWithIdentifier("infoButtonPressed", sender: view)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "infoButtonPressed" {
            let location = sender! as! MKAnnotationView
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! annotationInfoViewController
            controller.backButtonDelegate = self
            controller.locationToView = location.annotation!.title!
        }
    }
    func backButtonPressedFrom(controller: UIViewController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    //information "button"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//            pin!.pinTintColor = .Red
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        
        return pin
    }
    //Find users locations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
//        self.mapView.setRegion(region, animated: true)
        
//        self.locationManager.stopUpdatingLocation()
        //comparing distance between user and pin...not functional
        for landmark in annotations {
//            let pin = CLLocation(latitude: 37.338208, longitude: -121.886329)
            let pin = CLLocation(latitude: landmark.coordinate.latitude, longitude: landmark.coordinate.longitude)
//            let user = MKUserLocation.self
            let radius = 70.0
            if pin.distanceFromLocation(location!) < radius {
                if landmark.subtitle! == "in" {
                } else if landmark.subtitle! == "" {
                    placesNotification(landmark)
                }
//                print(pin.distanceFromLocation(location!))
//                if landmark.title! == "The Bread Basket" {
//                    print(landmark.title!)
//                }
            } else {
                landmark.subtitle = ""
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }

    
    func placesNotification(landmark: MKPointAnnotation) {
        // create a corresponding local notification
        if landmark.subtitle! != "in" {
            var notification = UILocalNotification()
            notification.alertBody = "You are close to \(landmark.title!)" // text that will be displayed in the notification
            landmark.subtitle = "in"
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            notification.fireDate = NSDate(timeIntervalSinceNow: 2) // todo item due date (when notification will be fired)
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            notification.userInfo = ["test": "test place"] // assign a unique identifier to the notification so that we can retrieve it later
            notification.category = "PLACES_CATEGORY"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
    }

    
    

}
