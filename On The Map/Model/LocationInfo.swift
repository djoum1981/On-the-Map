//
//  UserLocation.swift
//  On The Map
//
//  Created by Julien Laurent on 1/20/21.
//

import Foundation
struct LocationInfo: Codable {
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
}
