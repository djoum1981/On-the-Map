//
//  StudentInfo.swift
//  On The Map
//
//  Created by Julien Laurent on 1/15/21.
//
// contains information of the log in student
import Foundation

struct UserLocation: Codable {
    let userInfo: [UserInfo]
}

struct UserInfo: Codable {
    let createdAt, firstName, lastName: String
    let latitude, longitude: Double
    let mapString: String
    let mediaURL: String
    let objectID, uniqueKey, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case createdAt, firstName, lastName, latitude, longitude, mapString, mediaURL
        case objectID = "objectId"
        case uniqueKey, updatedAt
    }
    
    init(_ data: [String: AnyObject]) {
            self.createdAt = data["createdAt"] as? String ?? ""
              self.uniqueKey = data["uniqueKey"] as? String ?? ""
              self.firstName = data["firstName"] as? String ?? ""
              self.lastName = data["lastName"] as? String ?? ""
              self.mapString = data["mapString"] as? String ?? ""
              self.mediaURL = data["mediaURL"] as? String ?? ""
              self.latitude = data["latitude"] as? Double ?? 0.0
              self.longitude = data["longitude"] as? Double ?? 0.0
                self.objectID = data["objectId"] as? String ?? ""
              self.updatedAt = data["updatedAt"] as? String ?? ""
    }
}
