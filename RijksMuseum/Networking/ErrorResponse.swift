//
//  ErrorResponse.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 11/02/22.
//

import Foundation

public struct ErrorResponse: Codable {
  public var error: Error
  
  public struct Error: Codable {
    public var errors: [String]
  }
}
