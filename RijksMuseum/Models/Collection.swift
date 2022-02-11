//
//  Collection.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 11/02/22.
//

import Foundation

struct Collection: Codable {
    var artObjects: ArtObjects
}

struct ArtObjects: Codable {
    var id: String
    var objectNumber: String
    var title: String
    var principalOrFirstMaker: String
    var longTitle: String
    var webImage: WebImage
    var headerImage: HeaderImage
}

struct WebImage: Codable {
    var width: Int
    var height: Int
    var url: String
}

struct HeaderImage: Codable {
    var width: Int
    var height: Int
    var url: String
}
