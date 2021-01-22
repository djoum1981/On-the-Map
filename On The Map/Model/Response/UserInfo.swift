//
//  StudentInfo.swift
//  On The Map
//
//  Created by Julien Laurent on 1/15/21.
//
// contains information of the log in student
import Foundation


struct UserLocation : Codable {
    let results : [UserInfo]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([UserInfo].self, forKey: .results)
    }
}


struct UserInfo : Codable {
    let createdAt: String?
        let firstName: String
        let lastName: String
        let latitude: Double?
        let longitude: Double?
        let mapString: String?
        let mediaURL: String?
        let objectId: String?
        let uniqueKey: String?
        let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case firstName = "firstName"
        case lastName = "lastName"
        case latitude = "latitude"
        case longitude = "longitude"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case objectId = "objectId"
        case uniqueKey = "uniqueKey"
        case updatedAt = "updatedAt"
    }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
            firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
            lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
            latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
            longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
            mapString = try values.decodeIfPresent(String.self, forKey: .mapString)
            mediaURL = try values.decodeIfPresent(String.self, forKey: .mediaURL)
            objectId = try values.decodeIfPresent(String.self, forKey: .objectId)
            uniqueKey = try values.decodeIfPresent(String.self, forKey: .uniqueKey)
            updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        }
    
    
    init(_ info: [String: AnyObject]) {
        self.createdAt = info["createdAt"] as? String
        self.uniqueKey = info["uniqueKey"] as? String ?? ""
        self.firstName = info["firstName"] as? String ?? ""
        self.lastName = info["lastName"] as? String ?? ""
        self.mapString = info["mapString"] as? String ?? ""
        self.mediaURL = info["mediaURL"] as? String ?? ""
        self.latitude = info["latitude"] as? Double ?? 0.0
        self.longitude = info["longitude"] as? Double ?? 0.0
        self.objectId = info["objectId"] as? String
        self.updatedAt = info["updatedAt"] as? String
    }
    
    var labelName: String {
            var name = ""
            if !firstName.isEmpty {
                name = firstName
            }
            if !lastName.isEmpty {
                if name.isEmpty {
                    name = lastName
                } else {
                    name += " \(lastName)"
                }
            }
            if name.isEmpty {
                name = "FirstName LastName"
            }
            return name
        }
}

