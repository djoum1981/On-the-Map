//
//  ViewController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit
import SafariServices

class LoginController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginField.delegate = self
        passwordField.delegate = self
        
        loginIndicator(indicator: false)
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if passwordField.isFirstResponder {
            passwordField.endEditing(true)
        }else{
            loginField.endEditing(true)
        }
        signIn()
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        UIApplication.shared.open(OnTheMapClient.EndPoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func facebookSignUpPressed(_ sender: UIButton) {
    }
    
    func signIn() {
        let login = loginField.text
        let password = passwordField.text
        
        if login != "" && password != ""{
            //-MARK: show the next page
            DispatchQueue.main.async {
                self.loginIndicator(indicator: true)
            }
            
            OnTheMapClient.login(userEmail: login!, userPassword: password!) { (success, error) in
                
                if success{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "TabBarEntrySequee", sender: nil)
                        self.loginIndicator(indicator: false)
                    }
                }else{
                    DispatchQueue.main.async { [self] in
                        loginIndicator(indicator: false)
                        self.disPlayErrorMessage(title: "Login Error", message: "Please check your login creadential and try again later")
                    }
                }
            }
        }
    }
    
    func disPlayErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginIndicator(indicator: Bool) {
        if indicator{
            loginIndicator.startAnimating()
        }else{
            loginIndicator.stopAnimating()
        }
        signInButton.isEnabled = !indicator
       
    }
}

extension LoginController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let passwordField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            passwordField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == passwordField{
            signIn()
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}

