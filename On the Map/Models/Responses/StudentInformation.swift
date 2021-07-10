//
//  StudentInformation.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import Foundation

struct StudentInformation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
