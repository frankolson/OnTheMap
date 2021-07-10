//
//  CustomButton.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.primary
        setTitleColor(UIColor.white, for: .normal)
        setTitle(self.title(for: .normal)?.uppercased(), for: .normal)
    }

}
