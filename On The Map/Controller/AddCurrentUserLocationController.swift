//
//  AddCurrentUserLocationController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/19/21.
//

import UIKit
import CoreLocation

class AddCurrentUserLocation: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addLocationTextField: UITextField!
    
    //to attach the find the map button on the keyboard
    fileprivate func findOnMapButton() {
        let findOnMapButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        findOnMapButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        findOnMapButton.setTitle("Find On the Map", for: .normal)
        findOnMapButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        findOnMapButton.titleLabel?.font = .systemFont(ofSize: 20)
        findOnMapButton.addTarget(self, action: #selector(findOnMap), for: .touchUpInside)
        addLocationTextField.inputAccessoryView = findOnMapButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationTextField.delegate = self
        locationLabel.backgroundColor = UIColor(patternImage: UIImage(named: "map")!)
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddingCurrentUserLocation))
        
        HideShowKeyboardNotification()
        
        findOnMapButton()
    }
    
    @objc func findOnMap() {
        if let location = addLocationTextField.text{
            locationToSearch(placeName: location.trimmingCharacters(in: .whitespaces))
        }
    }
    
    func getLocation(forPlaceCalled name: String, complition: @escaping(CLLocation?) ->Void){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(name, completionHandler: {placemark, error in
            guard error  == nil else{
                print("Error in getlocation fonction \(error!.localizedDescription)")
                self.disPlayErrorMessage(title: "Location Error", message: "Please check the location and try again")
                return
            }
            
            guard let placemark = placemark?[0] else{
                print("*** Error in \(#function): placemark is nil")
                self.disPlayErrorMessage(title: "Location Error", message: "Please check the location and try again")
                complition(nil)
                return
            }
            
            guard let location = placemark.location else{
                self.disPlayErrorMessage(title: "Location Error", message: "Please check the location and try again")
                complition(nil)
                return
            }
            complition(location)
        })
    }
    
    //to alert the user when location is not correct
    func disPlayErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// Mark - to move the view when keyboard block the textfield
extension AddCurrentUserLocation{
    
    fileprivate func HideShowKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(AddCurrentUserLocation.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddCurrentUserLocation.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(){
        self.view.frame.origin.y = 0
    }
    @objc func cancelAddingCurrentUserLocation() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func locationToSearch(placeName: String) {
        getLocation(forPlaceCalled: placeName) { location in
            guard let location  = location else {return}
            if let locateOnMapAndAddLocationVC = self.storyboard?.instantiateViewController(identifier: "LocateOnMapAndAddLocationID") as? LocateOnMapAndAddWebSiteController{
                locateOnMapAndAddLocationVC.hidesBottomBarWhenPushed = true
                locateOnMapAndAddLocationVC.locationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                locateOnMapAndAddLocationVC.mapString = placeName
                self.navigationController?.pushViewController(locateOnMapAndAddLocationVC, animated: true)
            }
        }
    }
}

//-MARK: getlocation name textfield delegate method
extension AddCurrentUserLocation: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //show the button here
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let placeNameToSearch = textField.text{
            locationToSearch(placeName: placeNameToSearch.trimmingCharacters(in: .whitespaces))
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
