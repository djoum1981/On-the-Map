//
//  LoginResponse.swift
//  On The Map
//
//  Created by Julien Laurent on 1/13/21.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}


struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id, expiration: String
}


