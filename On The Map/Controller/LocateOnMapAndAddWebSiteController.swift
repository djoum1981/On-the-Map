//
//  LocateOnMapAndAddWebSiteController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/19/21.
//

import UIKit
import MapKit

class LocateOnMapAndAddWebSiteController: UIViewController{
    
    @IBOutlet weak var locateOnMapMapView: MKMapView!
    var locationCoordinate: CLLocationCoordinate2D?
    var mapAndMediaInfo = [String:Any]()
    
    var userInfo: StudentInformation?
    var objectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locateOnMapMapView.delegate = self
       
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelLocateOnMap))
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        submitLocation()
    }
    
    //submit user info to the server
    func submitLocation(){
        
        userInfo = userInfoToPost()
        
        if let userLocation = userInfo{
            if OnTheMapClient.Auth.objectId == ""{
                OnTheMapClient.postUserLocation(userInfo: userLocation) { (success, error) in
                    if success{
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.disPlayAlertMessage(title: "error", message: error?.localizedDescription ?? "")
                        }
                    }
                }
            }else{
                let alert = UIAlertController(title: "Warning", message: "This user is already exist.\nWould you like to update it", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                    OnTheMapClient.updateUserLocation(userInfo: userLocation) { (success, error) in
                        if success{
                            DispatchQueue.main.async {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.disPlayAlertMessage(title: "Error", message: error?.localizedDescription ?? "")
                            }
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let location = CLLocation(latitude: locationCoordinate?.latitude ?? 0.0, longitude: locationCoordinate?.longitude ?? 0.0)
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        locateOnMapMapView.setRegion(coordinateRegion, animated: true)
        
        let anAnotation = MKPointAnnotation()
        if let locationCoordinate = locationCoordinate{
            anAnotation.coordinate = locationCoordinate
            anAnotation.title = "\(OnTheMapClient.Auth.studentFirstName) \(OnTheMapClient.Auth.studentLastName)"
            anAnotation.subtitle = (mapAndMediaInfo["mediaURL"] as! String)
            locateOnMapMapView.addAnnotation(anAnotation)
        }
    }
    
    @objc func cancelLocateOnMap() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    //to alert the user when location is not correct
    func disPlayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //build the user info to post
    func userInfoToPost() -> StudentInformation {
        var userInfo = [
            "firstName": OnTheMapClient.Auth.studentFirstName,
            "lastName": OnTheMapClient.Auth.studentLastName,
            "longitude": locationCoordinate?.longitude as Any,
            "latitude": locationCoordinate?.latitude as Any,
            "mapString": mapAndMediaInfo["mapString"] as Any,
            "mediaURL": mapAndMediaInfo["mediaURL"] as Any,
            "uniqueKey": OnTheMapClient.Auth.key

        ] as [String: AnyObject]

        if let objectId = objectId{
            userInfo["objectId"] = objectId as AnyObject
        }
        return StudentInformation(userInfo)
    }
}

extension LocateOnMapAndAddWebSiteController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            if let linkToOpen = view.annotation?.subtitle{
                if let url = URL(string: linkToOpen ?? ""){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}



