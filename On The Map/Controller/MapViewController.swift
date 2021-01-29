//
//  MapNavigationController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var map: MKMapView!
    var mapAnotations = [MKPointAnnotation]()
    var resetMap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        navigationItem.title = "On The Map"
        
        let addPinButton = UIBarButtonItem(image: UIImage(named: "icon_pin"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(addPinButtonPress))
        
        let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(refreshButtonPressed))
        
        navigationItem.rightBarButtonItems = [refreshButton, addPinButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(logoutPressed))
    }
   
    fileprivate func getPinsForMap() {
        OnTheMapClient.getUsersLocation { (locations, error) in
            if let locations = locations{
                if locations.isEmpty{
                    self.disPlayErrorMessage(title: "Error", message: "An error occur.")
                    return
                }
                self.getPins(locations: locations)
            }
        }
    }
    
    func disPlayErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
            self.getPinsForMap() // try to refresh
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func logoutPressed() {
        OnTheMapClient.logout()
        self.dismiss(animated: true, completion: nil)
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
    
    func getPins(locations: [StudentInformation]){
        if locations.count < 1 {return}
        self.map.removeAnnotations(self.mapAnotations)
        self.mapAnotations.removeAll()
        for location in locations{
            let latitude = CLLocationDegrees(location.latitude ?? 0.0)
            let longitude = CLLocationDegrees(location.longitude ?? 0.0)
            let mediaURL = location.mediaURL
            let mapAnotationTitle = "\(location.firstName ) \(location.lastName)"
            let mapCoordonate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let anAnotation = MKPointAnnotation()
            anAnotation.coordinate = mapCoordonate
            anAnotation.title = mapAnotationTitle
            anAnotation.subtitle = mediaURL
            self.mapAnotations.append(anAnotation)
        }
        
        DispatchQueue.main.async {
            self.map.addAnnotations(self.mapAnotations)
            self.mapLoadingIndicator.stopAnimating()
            self.mapLoadingIndicator.isHidden = true
        }
    }
}

extension MapViewController: MKMapViewDelegate{
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

