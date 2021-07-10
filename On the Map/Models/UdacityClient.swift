//
//  UdacityClient.swift
//  On the Map
//
//  Created by Will Olson on 7/10/21.
//

import Foundation

class UdacityClient {
    enum Endpoints {
        case signUp
        
        var stringValue: String {
            switch self {
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
