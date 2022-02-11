//
//  NetworkManager.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 11/02/22.
//

import Foundation
import Moya
import RxSwift

public struct NetworkManager {
  
  public static let instance = NetworkManager()
  fileprivate let provider: MoyaProvider<MultiTarget>
  
  private init() {
    self.provider = MoyaProvider<MultiTarget>(
      plugins: []
    )
  }
}

public extension NetworkManager {
  
  func requestObject<T: TargetType, C: Decodable>(_ t: T, c: C.Type) -> Single<C> {
    return provider.rx.request(MultiTarget(t))
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .filterSuccessfulStatusAndRedirectCodes()
      .map(c.self)
      .catchError({ (error) in
        guard let errorResponse = error as? MoyaError else { return Single.error(NetworkError.IncorrectDataReturned) }
        switch errorResponse {
        case .underlying(let (e, _)):
          return Single.error(NetworkError(error: e as NSError))
        default:
          let body = try errorResponse.response?.map(ErrorResponse.self)
          if let body = body {
            return Single.error(NetworkError.SoftError(message: body.error.errors.first))
          } else {
            return Single.error(NetworkError.IncorrectDataReturned)
          }
        }
      })
    
  }
  
}
