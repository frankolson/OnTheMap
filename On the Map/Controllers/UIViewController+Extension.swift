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
            print("error: \(String(describing: error))")
        }
    }
}
