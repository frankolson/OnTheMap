//
//  UIViewController+Extension.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import UIKit

extension UIViewController {
    
    // MARK: Actions
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityClient.logout(completion: handleLogoutRequest(success:error:))
    }
    
    // MARK: Logout helpers
    
    func handleLogoutRequest(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Logout Error", message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: Alerts
    
    func showAlert(title: String, message: String) {
        print("Error: \(message)")
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}
