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
        <#code#>
    }
    
    var method: Method {
        <#code#>
    }
    
    var sampleData: Data {
        <#code#>
    }
    
    var task: Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}
