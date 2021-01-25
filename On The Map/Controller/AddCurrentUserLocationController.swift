//
//  AddCurrentUserLocationController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/19/21.
//

import UIKit
import CoreLocation

class AddCurrentUserLocation: UIViewController {
    
    @IBOutlet weak var linkToShareTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addLocationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationTextField.delegate = self
        linkToShareTextField.delegate = self
        customizeTextField(textField: addLocationTextField)
        customizeTextField(textField: linkToShareTextField)
        locationLabel.backgroundColor = UIColor(patternImage: UIImage(named: "map")!)
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddingCurrentUserLocation))
        
        HideShowKeyboardNotification()
        
        findOnMapButton()
    }
    
    //to attach the find the map button on the keyboard
    fileprivate func findOnMapButton() {
        let findOnMapButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        findOnMapButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        findOnMapButton.setTitle("Find Location", for: .normal)
        findOnMapButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        findOnMapButton.titleLabel?.font = .systemFont(ofSize: 20)
        findOnMapButton.addTarget(self, action: #selector(findOnMap), for: .touchUpInside)
        linkToShareTextField.inputAccessoryView = findOnMapButton
    }
    
    @objc func findOnMap() {
        if let location = addLocationTextField.text, let linkToShare = linkToShareTextField.text{
            locationToSearch(placeName: location.trimmingCharacters(in: .whitespaces), link: linkToShare.trimmingCharacters(in: .whitespaces))
        }
    }
    
    func getLocation(forPlaceCalled name: String, complition: @escaping(CLLocation?) ->Void){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(name, completionHandler: {placemark, error in
            guard error  == nil else{
                self.disPlayErrorMessage(title: "Location Error", message: "Please check the location and try again")
                return
            }
            
            guard let placemark = placemark?[0] else{
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
    
    //to alert the user when location/link is not correct
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
    
    fileprivate func locationToSearch(placeName: String, link: String) {
        getLocation(forPlaceCalled: placeName) { location in
            guard let location  = location else {return}
            if let locateOnMapAndAddLocationVC = self.storyboard?.instantiateViewController(identifier: "LocateOnMapAndAddLocationID") as? LocateOnMapAndAddWebSiteController{
                locateOnMapAndAddLocationVC.hidesBottomBarWhenPushed = true
                locateOnMapAndAddLocationVC.locationCoordinate = CLLocationCoordinate2D(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
                locateOnMapAndAddLocationVC.mapAndMediaInfo["mapString"] = placeName
                if !self.checkLinkToshare(userInput: link){return}
                    locateOnMapAndAddLocationVC.mapAndMediaInfo["mediaURL"] = link
                    self.navigationController?.pushViewController(locateOnMapAndAddLocationVC, animated: true)
                
            }
        }
    }
    
    //verify the provided input is a valid url
    func checkLinkToshare(userInput: String)->Bool {
        guard let url = URL(string: userInput), UIApplication.shared.canOpenURL(url) else {
            
            disPlayErrorMessage(title: "Invalid URL", message: "Please check the URL link and try again\nThe URL format should be complete with https:// ")
            return false
        }
        return true
    }
}

//-MARK: getlocation name textfield delegate method
extension AddCurrentUserLocation: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == addLocationTextField{
            
        }else if textField == linkToShareTextField{
            
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let linkField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            linkField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
            //send it over here
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //add border on the texfield
    func customizeTextField(textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.layer.cornerRadius = 4
    }
}


