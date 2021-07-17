//
//  ProfileResponse.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import Foundation

struct StudentProfileResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
