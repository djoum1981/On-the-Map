//
//  PostLocationResponse.swift
//  On The Map
//
//  Created by Julien Laurent on 1/16/21.
//

import Foundation

struct PostLocationResponse : Codable {

        let createdAt : String?
        let objectId : String?

        enum CodingKeys: String, CodingKey {
                case createdAt = "createdAt"
                case objectId = "objectId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
                objectId = try values.decodeIfPresent(String.self, forKey: .objectId)
        }

}


struct UpdateResponse : Codable {

        let updatedAt : String?
    
        enum CodingKeys: String, CodingKey {
                case updatedAt = "updatedAt"
        }
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        }

}


