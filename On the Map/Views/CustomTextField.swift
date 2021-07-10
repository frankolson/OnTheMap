//
//  CustomTextField.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import UIKit

class CustomTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
    }
}
