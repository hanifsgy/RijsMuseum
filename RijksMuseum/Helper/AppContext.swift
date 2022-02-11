//
//  AppContext.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 11/02/22.
//

import Foundation

public class AppContext {
  
  init() {
    
  }
  
  public static var instance: AppContext {
    return AppContext()
  }
  
  public func infoForKey(_ key: String) -> String {
    return ((Bundle.main.infoDictionary?[key] as? String)?
      .replacingOccurrences(of: "\\", with: ""))!
  }
}
