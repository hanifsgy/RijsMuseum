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
        let validO: Driver<Void>
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
        
        
//        let valid = Observable.combineLatest(usernameS, passwordS)
//            .flatMapLatest { (username, password) -> Observable<Bool> in
//                print("Usernamje === \(username) password === \(password)")
//            }
//            .filter { _ in $0.count > 3 && $1.count > 3}
//            .asDriverOnErrorJustComplete()
        
        let done = buttonS
            .flatMapLatest { (_) -> Observable<Void> in
                return navigator.launchHome()
            }
            .asDriverOnErrorJustComplete()
        
        output = Output(validO: Observable.just(()).asDriverOnErrorJustComplete(),
                        buttonO: done)
    }
}

