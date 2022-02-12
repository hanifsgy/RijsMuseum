//
//  RijksAPI.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 11/02/22.
//

import Moya

enum RijksAPI {
    
    case collection(p: Int, ps: Int)
    
}

extension RijksAPI: TargetType {
    var baseURL: URL {
        return URL(string: AppContext.instance.infoForKey("BASE_URL"))!
    }
    
    var path: String {
        switch self {
        case .collection:
            return "collection"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
      switch self.method {
      case .post, .put:
        return JSONEncoding.default
      default:
        return URLEncoding.default
      }
    }
    
    var task: Task {
      switch self {
      default:
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .collection(let page, let perPage):
            return [
                "p": page,
                "ps": perPage,
                "key": AppContext.instance.infoForKey("API_KEY")
            ]
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
