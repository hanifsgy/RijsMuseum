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

protocol KeyNamespaceable {
    static func namespace<T: RawRepresentable>(_ key: T) -> String where T.RawValue == String
}

extension KeyNamespaceable {
    private static func namespace(_ key: String) -> String {
        return "\(Self.self).\(key)"
    }
    
    static func namespace<T: RawRepresentable>(_ key: T) -> String where T.RawValue == String {
        return namespace(key.rawValue)
    }
}

protocol AccountDefaultable: KeyNamespaceable {
    associatedtype AccountDefaultKey: RawRepresentable
}

extension AccountDefaultable where AccountDefaultKey.RawValue == String {
    
    static func set(_ value: Any, forKey key: AccountDefaultKey) {
        UserDefaults.standard.set(value, forKey: namespace(key))
    }
    
    static func get<T>(forKey key: AccountDefaultKey) -> T? {
        guard let value = UserDefaults.standard.object(forKey: namespace(key)) as? T else {
            return nil
        }
        
        return value
    }
    
    static func reset(forKey key: AccountDefaultKey) {
        UserDefaults.standard.removeObject(forKey: namespace(key))
    }
    
    static func reset() {
        for (key, _) in list() {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    static private func list() -> [String: Any] {
        let allDefaults = UserDefaults.standard.dictionaryRepresentation()
        var myDefaults = [String: Any]()
        
        for (key, value) in allDefaults {
            if key.hasPrefix("\(Self.self)") {
                myDefaults[key] = value
            }
        }
        
        return myDefaults
    }
}

extension UserDefaults {
    
    struct Account: AccountDefaultable {
        private init() { }
        
        enum AccountDefaultKey: String {
            case firstTimeInstall
            case isLoggedIn
        }
    }
}
