//
//  AppCoordinator.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 12/02/22.
//

import RxSwift
import AsyncDisplayKit

class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let navigationController: ASNavigationController
    
    init(window: UIWindow, navigationController: ASNavigationController) {
        self.window = window
        self.window.backgroundColor = UIColor.white
        self.navigationController = navigationController
    }
    override func start() -> Observable<CoordinationResult> {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        return self.coordinate(to: homeCoordinator)
    }
}

