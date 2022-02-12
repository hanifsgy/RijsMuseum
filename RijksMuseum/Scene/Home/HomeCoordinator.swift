//
//  HomeCoordinator.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 12/02/22.
//

import RxSwift
import AsyncDisplayKit

protocol HomeNavigator: AnyObject {
    func launchDetail(object: ArtObjects) -> Observable<Void>
}

final class HomeCoordinator: BaseCoordinator<Void> {
    private let navigationController: ASNavigationController
    
    init(navigationController: ASNavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let homeViewModel = HomeViewModel(navigator: self)
        let homeController = HomeController(viewModel: homeViewModel)
        navigationController.pushViewController(homeController, animated: true)
        return Observable.empty()
    }
}

extension HomeCoordinator: HomeNavigator {
    func launchDetail(object: ArtObjects) -> Observable<Void> {
        print("NAVIGATIONS DETAIL \(object.id) image == \(object.headerImage.url)")
        return Observable.just(())
    }
    
    
}
