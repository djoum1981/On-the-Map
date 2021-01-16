//
//  LoginResponse.swift
//  On The Map
//
//  Created by Julien Laurent on 1/13/21.
//

import Foundation

// MARK: - Welcome
struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

// MARK: - Account
struct Account: Codable {
    let registered: Bool
    let key: String
}

// MARK: - Session
struct Session: Codable {
    let id, expiration: String
}
