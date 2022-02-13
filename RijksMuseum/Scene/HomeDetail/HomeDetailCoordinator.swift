//
//  HomeDetailCoordinator.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 13/02/22.
//

import RxSwift
import AsyncDisplayKit

protocol HomeDetailNavigator: AnyObject {
    func back() -> Observable<Void>
}

final class HomeDetailCoordinator: BaseCoordinator<Void> {
    private let navigationController: ASNavigationController
    private let item: ArtObjects
    
    init(navigationController: ASNavigationController, item: ArtObjects) {
        self.navigationController = navigationController
        self.item = item
    }
    
    override func start() -> Observable<Void> {
        let homeDetailViewModel = HomeDetailViewModel(navigation: self, item: self.item)
        let homeDetailController = HomeDetailController(viewModel: homeDetailViewModel)
        navigationController.pushViewController(homeDetailController, animated: true)
        return Observable.empty()
    }
}

extension HomeDetailCoordinator: HomeDetailNavigator {
    func back() -> Observable<Void> {
        self.navigationController.popViewController(animated: true)
        return Observable.just(())
    }
}
