//
//  SessionResponse.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import Foundation

struct SessionResponse: Codable {
    let account: AccountDetails
    let session: SessionDetails
}

struct AccountDetails: Codable {
    let registered: Bool
    let key: String
}

struct SessionDetails: Codable {
    let id: String
    let expiration: String
}
