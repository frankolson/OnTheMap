//
//  LoginViewController.swift
//  On the Map
//
//  Created by Will Olson on 7/9/21.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    // MARK: Actions
    
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.createSession(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? "",
            completion: handleSessionResponse(success:error:)
        )
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    // MARK: Login helpers
    
    func handleSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            passwordTextField.text = ""
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}
