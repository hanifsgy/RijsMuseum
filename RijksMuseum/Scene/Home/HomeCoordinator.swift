//
//  HomeCoordinator.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 12/02/22.
//

import RxSwift
import AsyncDisplayKit

final class HomeCoordinator: BaseCoordinator<Void> {
    private let navigationController: ASNavigationController
    
    init(navigationController: ASNavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let homeViewModel = HomeViewModel()
        let homeController = HomeController(viewModel: homeViewModel)
        navigationController.pushViewController(homeController, animated: true)
        return Observable.empty()
    }
}
