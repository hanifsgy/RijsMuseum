//
//  LoginViewModel.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 13/02/22.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    var input: Input
    var output: Output!
    
    struct Input {
        let usernameI: AnyObserver<String>
        let passwordI: AnyObserver<String>
        let buttonI: AnyObserver<Void>
    }
    
    struct Output {
        let validO: Driver<Bool>
        let buttonO: Driver<Void>
    }
    
    private let usernameS = PublishSubject<String>()
    private let passwordS = PublishSubject<String>()
    private let buttonS = PublishSubject<Void>()
    private let navigator: LoginNavigator
    
    init(navigator: LoginNavigator) {
        self.navigator = navigator
        
        input = Input(usernameI: usernameS.asObserver(),
                      passwordI: passwordS.asObserver(),
                      buttonI: buttonS.asObserver())
        
        let validityCheck = Observable.combineLatest(usernameS, passwordS)
            .map({ (username, password) in
                var state: Bool = false
                if username.count > 3 && password.count > 3 {
                    state = true
                }
                return state
            })
            .startWith(false)
            .asDriverOnErrorJustComplete()
        
        let done = buttonS
            .flatMapLatest { (_) -> Observable<Void> in
                UserDefaults.Account.set(true, forKey: .isLoggedIn)
                return navigator.launchHome()
            }
            .asDriverOnErrorJustComplete()
        
        output = Output(validO: validityCheck,
                        buttonO: done)
    }
}

