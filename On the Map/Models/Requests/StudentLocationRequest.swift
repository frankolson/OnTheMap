//
//  StudentLocationRequest.swift
//  On the Map
//
//  Created by Will Olson on 7/16/21.
//

import Foundation

struct StudentLocationRequest:Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
}
