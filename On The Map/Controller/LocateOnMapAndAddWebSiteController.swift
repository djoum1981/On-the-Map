//
//  LocateOnMapAndAddWebSiteController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/19/21.
//

import UIKit
import MapKit

class LocateOnMapAndAddWebSiteController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var linkToShareTextField: UITextField!
    @IBOutlet weak var locateOnMapMapView: MKMapView!
    
    //var locationCoordonate = [String: CLLocationDegrees]()
    var locationCoordinate: CLLocationCoordinate2D?
    
    var mapString: String?
    var userInfo: UserInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locateOnMapMapView.delegate = self
        linkToShareTextField.delegate = self
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelLocateOnMap))
        
        keyBoardNorfication()
        submitButton()
        }
    
    fileprivate func submitButton() {
        let findOnMapButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        findOnMapButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        findOnMapButton.setTitle("Submit", for: .normal)
        findOnMapButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        findOnMapButton.titleLabel?.font = .systemFont(ofSize: 20)
        findOnMapButton.addTarget(self, action: #selector(submitLocation), for: .touchUpInside)
        linkToShareTextField.inputAccessoryView = findOnMapButton
    }
    
    @objc func submitLocation(){
        
        print("try to submit the location")
        guard checkLinkToshare(userInput: linkToShareTextField.text!) != nil else{
            return
        }
        
        print("I pass it till here")
        
        
        if let userLocation = userInfo{
            _ =  LocationInfo(objectId: userLocation.objectId ?? "", uniqueKey: userLocation.uniqueKey, firstName: userLocation.firstName, lastName: userLocation.lastName, mapString: mapString, mediaURL: linkToShareTextField.text, latitude: locationCoordinate?.latitude, longitude: locationCoordinate?.longitude, createdAt: userLocation.createdAt ?? "", updatedAt: userLocation.updatedAt ?? "")
        }
        if let userInfo = userInfo{
        if OnTheMapClient.Auth.objectId == ""{
            OnTheMapClient.postUserLocation(userInfo: userInfo) { (success, error) in
                if success{
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    print("success")
                }else{
                    DispatchQueue.main.async {
                        self.disPlayAlertMessage(title: "Error!!!", message: "unable to post your info")
                    }
                }
            }
        }
        }
    }
    
    func checkLinkToshare(userInput: String) -> URL? {
        guard let url = URL(string: userInput), UIApplication.shared.canOpenURL(url) else {
            disPlayAlertMessage(title: "Invalid URL", message: "Please check - http:// -  is included in your url")
            return nil
        }
        return url
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "map.jpg")!)
        
        let location = CLLocation(latitude: locationCoordinate?.latitude ?? 0.0, longitude: locationCoordinate?.longitude ?? 0.0)
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        locateOnMapMapView.setRegion(coordinateRegion, animated: true)
        
        let anAnotation = MKPointAnnotation()
        if let locationCoordinate = locationCoordinate{
        anAnotation.coordinate = locationCoordinate
        anAnotation.title = "\(OnTheMapClient.Auth.studentFirstName) \(OnTheMapClient.Auth.studentLastName)"
        locateOnMapMapView.addAnnotation(anAnotation)
        linkToShareTextField.alpha = 1.0
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
//    func userInfoToPost() -> UserInfo {
//        var userInfo = [
//            
//        ]
//        return UserInfo(userInfo)
//    }
    
    /*
     the following will show and scroll the view
     */
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    fileprivate func keyBoardNorfication() {
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(LocateOnMapAndAddWebSiteController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(LocateOnMapAndAddWebSiteController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

extension LocateOnMapAndAddWebSiteController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //show the button
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //submit post an return to root view controller
        return true
    }
}
