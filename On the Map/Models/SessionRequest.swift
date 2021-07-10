//
//  SessionRequest.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import Foundation

struct SessionRequest: Codable {
    let udacity: LoginDetails
}

struct LoginDetails: Codable {
    let username: String
    let password: String
}
