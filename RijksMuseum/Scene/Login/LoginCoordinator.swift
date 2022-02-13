//
//  LoginCoordinator.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 13/02/22.
//

import Foundation
import RxSwift
import AsyncDisplayKit

protocol LoginNavigator: AnyObject {
    func launchHome() -> Observable<Void>
}

final class LoginCoordinator: BaseCoordinator<Void> {
    private let navigationController: ASNavigationController
    
    init(navigationController: ASNavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let loginViewModel = LoginViewModel(navigator: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        navigationController.setViewControllers([loginViewController], animated: true)
        return Observable.empty()
    }
}

extension LoginCoordinator: LoginNavigator {
    func launchHome() -> Observable<Void> {
        return Observable.just(())
    }
}
