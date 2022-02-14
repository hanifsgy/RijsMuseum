//
//  DrawerViewController.swift
//  RijksMuseum
//
//  Created by Muhammad Hanif Sugiyanto on 14/02/22.
//

import UIKit

class DrawerViewController: UIViewController {
    
    let transitionManager = DrawerTransitionManager()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
