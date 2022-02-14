//
//  DrawerCoordinator.swift
//  RijksMuseum
//
//  Created by Muhammad Hanif Sugiyanto on 14/02/22.
//

import Foundation
import RxSwift
import AsyncDisplayKit

final class DrawerCoordnator: BaseCoordinator<Void> {
    private let navigationController: ASNavigationController
    
    init(navigationController: ASNavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let drawerController = DrawerViewController()
        navigationController.present(drawerController, animated: true, completion: nil)
        return Observable.empty()
    }
}
