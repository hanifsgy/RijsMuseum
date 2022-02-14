//
//  AppCoordinator.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 12/02/22.
//

import RxSwift
import AsyncDisplayKit
import Foundation

class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let navigationController: ASNavigationController
    var firstTimeInstall: Bool = true
    var isLoggedIn: Bool = false
    
    init(window: UIWindow, navigationController: ASNavigationController) {
        self.window = window
        self.window.backgroundColor = UIColor.white
        self.navigationController = navigationController
    }
    override func start() -> Observable<CoordinationResult> {
        if let firstTimeInstall: Bool = UserDefaults.Account.get(forKey: .firstTimeInstall),
           let isLoggedIn: Bool = UserDefaults.Account.get(forKey: .isLoggedIn){
            self.firstTimeInstall = firstTimeInstall
            self.isLoggedIn = isLoggedIn
        }
        if firstTimeInstall && isLoggedIn == false {
            UserDefaults.Account.reset()
            UserDefaults.Account.set(false, forKey: .firstTimeInstall)
            let loginCoordinator = LoginCoordinator(navigationController: navigationController)
            return self.coordinate(to: loginCoordinator)
        } else {
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            return self.coordinate(to: homeCoordinator)
        }
    }
}

