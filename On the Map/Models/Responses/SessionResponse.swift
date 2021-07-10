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
