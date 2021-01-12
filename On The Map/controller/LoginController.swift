//
//  ViewController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit

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
        signIn()
       
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func facebookSignUpPressed(_ sender: UIButton) {
    }
    
    func signIn() {
        let login = loginField.text
        let password = passwordField.text
        
        if login != "" && password != ""{
            //-MARK: show the next page
        }
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
        if textField == loginField && textField.text == ""{
            textField.placeholder = "Please enter you user name"
            return false
        }else if textField == passwordField && textField.text == ""{
            textField.placeholder = "Please enter your password"
            return false
        }
        return true
    }
}

