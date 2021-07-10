//
//  UdacityResponse.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import Foundation

struct UdacityResponse: Codable {
    let status: Int
    let error: String
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
