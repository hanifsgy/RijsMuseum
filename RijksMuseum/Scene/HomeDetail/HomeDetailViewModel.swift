//
//  HomeDetailViewModel.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 13/02/22.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeDetailViewModel: ViewModelType {
    
    var input: Input
    var output: Output!
    
    struct Input {
        let backI: AnyObserver<Void>
    }
    
    struct Output {
        let backO: Driver<Void>
    }
    
    private let backSubject = PublishSubject<Void>()
}
