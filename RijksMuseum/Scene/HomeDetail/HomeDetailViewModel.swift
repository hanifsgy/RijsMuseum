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
        let itemO: Driver<ArtObjects>
    }
    
    private let backSubject = PublishSubject<Void>()
    private let navigator: HomeDetailNavigator
    
    init(navigation: HomeDetailNavigator, item: ArtObjects) {
        self.navigator = navigation
        
        input = Input(backI: backSubject.asObserver())
        
        let back = backSubject
            .flatMapLatest { (_) -> Observable<Void> in
                return navigation.back()
            }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let item = Observable.just(item)
            .asDriverOnErrorJustComplete()
            
        
        output = Output(backO: back,
                        itemO: item)
    }
}
