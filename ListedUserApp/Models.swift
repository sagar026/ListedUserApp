//
//  Models.swift
//  ListedUserApp
//
//  Created by Vidhyasagar on 05/05/25.
//

import Foundation

typealias UserListResponse = [UserListElement]

struct UserListElement: Codable {
    let id: Int?
    let name, username, email: String?
    let address: Address?
    let phone, website: String?
    let company: Company?
}

struct Address: Codable {
    let street, suite, city, zipcode: String?
    let geo: Geo?
}

struct Geo: Codable {
    let lat, lng: String?
}

struct Company: Codable {
    let name, catchPhrase, bs: String?
}
