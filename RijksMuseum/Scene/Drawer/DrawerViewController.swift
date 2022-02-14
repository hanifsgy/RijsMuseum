//
//  DrawerViewController.swift
//  RijksMuseum
//
//  Created by Muhammad Hanif Sugiyanto on 14/02/22.
//

import UIKit
import RxSwift

class DrawerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let transitionManager = DrawerTransitionManager()
    let section = [
        "User",
        "Logout"
    ]
    let viewModel: DrawerViewModel!
    let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: DrawerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = nil
        tableView.dataSource = nil
        
        viewModel.output.items
            .drive(tableView.rx.items) { tableView, row, item -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = item
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .do(onNext: { (_) in
                self.transitionManager.dismiss()
            })
            .bind(to: viewModel.input.itemSelectedI)
            .disposed(by: disposeBag)
        
        viewModel.output.itemSelectedO
            .drive()
            .disposed(by: disposeBag)
    }
}
