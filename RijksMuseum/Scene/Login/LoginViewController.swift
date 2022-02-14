//
//  LoginViewController.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 13/02/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    private let viewModel: LoginViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfUsername.rx.text
            .orEmpty
            .distinctUntilChanged()
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.usernameI)
            .disposed(by: disposeBag)
        
        tfPassword.rx.text
            .orEmpty
            .distinctUntilChanged()
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.passwordI)
            .disposed(by: disposeBag)
        
        buttonLogin.rx.controlEvent([.touchUpInside])
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.buttonI)
            .disposed(by: disposeBag)
        
        viewModel.output.validO
            .do(onNext: { [weak self] value in
                guard let wSelf = self else { return }
                wSelf.buttonLogin.isEnabled = value
            })
            .drive()
            .disposed(by: disposeBag)
                
        viewModel.output.buttonO
            .do(onNext: { [weak self] (_) in
                guard let wSelf = self else { return }
                wSelf.view.endEditing(true)
            })
            .drive()
            .disposed(by: disposeBag)
    }
}
