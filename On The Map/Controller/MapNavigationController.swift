//
//  MapNavigationController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit
import MapKit

class MapNavigationController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    var mapAnotations = [MKPointAnnotation]()
    var resetMap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        navigationItem.title = "On The Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_pin"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(addPinButtonPress))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_refresh"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(refreshButtonPressed))
    }
    
    //var studentLocations: Array<UserInfo> = Array()
    
    fileprivate func getPinsForMap() {
        OnTheMapClient.getUsersLocation { (locations, error) in
            if let locations = locations{
                self.getPins(locations: locations)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPinsForMap()
    }
    
    @objc func addPinButtonPress() {
        if let addCurrentUserLocationVC = storyboard?.instantiateViewController(identifier: "AddCurrentUserLocationID"){
            addCurrentUserLocationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(addCurrentUserLocationVC, animated: true)
        }
        
    }
    
    @objc func refreshButtonPressed(){
        getPinsForMap()
    }
    
    
    func getPins(locations: [UserInfo]){
        if locations.count < 1 {return}
        self.map.removeAnnotations(self.mapAnotations)
        self.mapAnotations.removeAll()
        for location in locations{
            let latitude = CLLocationDegrees(location.latitude ?? 0.0)
            let longitude = CLLocationDegrees(location.longitude ?? 0.0)
            let mediaURL = location.mediaURL
            let mapAnotationTitle = "\(location.firstName ?? "") \(location.lastName ?? "")"
            let mapCoordonate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let anAnotation = MKPointAnnotation()
            anAnotation.coordinate = mapCoordonate
            anAnotation.title = mapAnotationTitle
            anAnotation.subtitle = mediaURL
            self.mapAnotations.append(anAnotation)
        }
        
        DispatchQueue.main.async {
            self.map.addAnnotations(self.mapAnotations)
        }
    }
}

extension MapNavigationController: MKMapViewDelegate{
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

