//
//  ViewController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit
import SafariServices

class LoginController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginField.becomeFirstResponder()
        loginField.delegate = self
        passwordField.delegate = self
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
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com"){
            let safaryVC = SFSafariViewController(url: url)
            present(safaryVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func facebookSignUpPressed(_ sender: UIButton) {
    }
    
    func signIn() {
        let login = loginField.text
        let password = passwordField.text
        
        if login != "" && password != ""{
            //-MARK: show the next page
            OnTheMapClient.login(userEmail: login!, userPassword: password!) { (success, error) in
               
                if success{
                    DispatchQueue.main.async {
                        print("login success")
                        self.performSegue(withIdentifier: "TabBarEntrySequee", sender: nil)
                    }
                }else{
                    DispatchQueue.main.async {
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
}

extension LoginController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginField{
            passwordField.becomeFirstResponder()
        }else if passwordField.isFirstResponder{
            passwordField.resignFirstResponder()
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

