//
//  ViewController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit
import SafariServices

class LoginController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "map")!)
        loginField.layer.borderWidth = 2
        loginField.layer.borderColor = #colorLiteral(red: 0, green: 0.6990359426, blue: 0.9034714699, alpha: 1)
        loginField.layer.cornerRadius = 8
        passwordField.layer.borderWidth = 2
        passwordField.layer.borderColor = #colorLiteral(red: 0, green: 0.6990359426, blue: 0.9034714699, alpha: 1)
        passwordField.layer.cornerRadius = 8
        
        loginField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        loginField.delegate = self
        passwordField.delegate = self
        loginIndicator.isHidden = true
    }
    

    
    @IBAction func loginPressed(_ sender: UIButton) {
        signIn()
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        UIApplication.shared.open(OnTheMapClient.EndPoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    
    func signIn() {
        let login = loginField.text
        let password = passwordField.text
        
        if !NetworkMonitor.shared.isConnected{
            disPlayErrorMessage(title: "Connection Error", message: "Please check you internet connection and try again")
            return
        }
        
        if login != "" && password != ""{
            
            OnTheMapClient.login(userEmail: login!, userPassword: password!) { (success, error) in
              
                DispatchQueue.main.async {
                    self.loginIndicator.isHidden = false
                    self.loginIndicator.startAnimating()
                    self.loginIndicator.startAnimating()
                }
                
                if success{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "TabarEntrySeque", sender: nil)
                        self.loginIndicator.stopAnimating()
                        self.loginIndicator.isHidden = true
                    }
                }else{
                    DispatchQueue.main.async {
                        self.loginIndicator.isHidden = true
                        self.disPlayErrorMessage(title: "Login Error", message: "Please check your login creadential and try again later")
                    }
                }
            }
        }
    }
    
    func disPlayErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

