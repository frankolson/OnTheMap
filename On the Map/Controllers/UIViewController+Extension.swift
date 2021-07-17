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
            print("Error: \(String(describing: error))")
        }
    }
    
    // MARK: Alerts
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}
