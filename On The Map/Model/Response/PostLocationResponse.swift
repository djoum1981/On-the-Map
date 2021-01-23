//
//  PostLocationResponse.swift
//  On The Map
//
//  Created by Julien Laurent on 1/16/21.
//

import Foundation

struct PostLocationResponse : Codable {
    let createdAt, objectID: String

        enum CodingKeys: String, CodingKey {
            case createdAt
            case objectID = "objectId"
        }
}

struct UpdateResponse : Codable {
    
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updatedAt"
    }
}


