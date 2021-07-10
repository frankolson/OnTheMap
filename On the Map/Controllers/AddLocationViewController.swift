//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Attributes
    
    var location = CLLocation()

    // MARK: Outlets

    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var urlTextField: CustomTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = self
        urlTextField.delegate = self
        locationTextField.text = ""
        urlTextField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Actions

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func findLocation(_ sender: Any) {
        setGeocoding(true)
        CLGeocoder().geocodeAddressString(locationTextField.text ?? "") { placemarks, error in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                self.setGeocoding(false)
                self.showAlert(title: "Bad Location", message: "The location you selected could not be found")
                return
            }
            
            self.setGeocoding(false)
            self.location = location
            self.performSegue(withIdentifier: "findLocation", sender: self)
        }
    }
    
    // MARK: Networking
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation" {
            let controller = segue.destination as! FindLocationViewController
            controller.location = location
            controller.locationString = locationTextField.text ?? ""
            controller.urlString = urlTextField.text ?? ""
        }
    }
    
    // MARK: Helper
    
    func setGeocoding(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}
