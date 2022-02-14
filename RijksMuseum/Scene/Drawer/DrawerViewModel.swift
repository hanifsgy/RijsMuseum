//
//  DrawerViewModel.swift
//  RijksMuseum
//
//  Created by Muhammad Hanif Sugiyanto on 14/02/22.
//

import Foundation
import RxSwift
import RxCocoa

final class DrawerViewModel: ViewModelType {
    
    var input: Input
    var output: Output!
    
    struct Input {
        let itemSelectedI: AnyObserver<IndexPath>
    }
    
    struct Output {
        let itemSelectedO: Driver<Void>
        let items: Driver<[String]>
    }
    
    private let itemSelectedS = PublishSubject<IndexPath>()
    private let navigator: DrawerNavigator
    
    init(navigator: DrawerNavigator) {
        self.navigator = navigator
        
        input = Input(itemSelectedI: itemSelectedS.asObserver())
        
        let itemItemSelect = itemSelectedS
            .flatMapLatest { index -> Observable<Void> in
                if index.row == 1 {
                    UserDefaults.Account.reset()
                    UserDefaults.Account.set(false, forKey: .isLoggedIn)
                    return navigator.logout()
                } else {
                    return Observable.just(())
                }
            }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let items = Observable.just([
            "User",
            "Logout"
        ]).asDriverOnErrorJustComplete()
        
        output = Output(itemSelectedO: itemItemSelect,
                        items: items)
    }
}
