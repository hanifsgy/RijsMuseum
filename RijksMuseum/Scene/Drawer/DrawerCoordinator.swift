//
//  DrawerCoordinator.swift
//  RijksMuseum
//
//  Created by Muhammad Hanif Sugiyanto on 14/02/22.
//

import Foundation
import RxSwift
import AsyncDisplayKit

protocol DrawerNavigator: AnyObject {
    func logout() -> Observable<Void>
}

final class DrawerCoordnator: BaseCoordinator<Void> {
    private let navigationController: ASNavigationController
    
    init(navigationController: ASNavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewModel = DrawerViewModel(navigator: self)
        let drawerController = DrawerViewController(viewModel: viewModel)
        navigationController.present(drawerController, animated: true, completion: nil)
        return Observable.empty()
    }
}

extension DrawerCoordnator: DrawerNavigator {
    func logout() -> Observable<Void> {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        return loginCoordinator.start()
    }
}
