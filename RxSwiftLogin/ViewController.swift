//
//  ViewController.swift
//  RxSwiftLogin
//
//  Created by KS on 2022/01/02.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    private let loginViewModel = LoginViewModel()
    private let disposebag = DisposeBag()

    @IBOutlet weak var usarnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!



    override func viewDidLoad() {
        super.viewDidLoad()

        usarnameTextField.becomeFirstResponder()

        usarnameTextField.rx.text.map { $0 ?? "" }
        .bind(to: loginViewModel.usernameTextPublishSubject)
        .disposed(by: disposebag)

        passwordTextField.rx.text.map { $0 ?? "" }
        .bind(to: loginViewModel.passwordTextPUblishSubject)
        .disposed(by: disposebag)

        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposebag)

        loginViewModel.isValid().map { $0 ? 1 : 0.5 }.bind(to: loginButton.rx.alpha)
            .disposed(by: disposebag)
    }


    @IBAction func tappedLoginButton(_ sender: UIButton) {
        print("Tapped Login button")
    }
}

class LoginViewModel {

    let usernameTextPublishSubject = PublishSubject<String>()
    let passwordTextPUblishSubject = PublishSubject<String>()

    func isValid() -> Observable<Bool> {
        Observable.combineLatest(usernameTextPublishSubject.asObservable(),passwordTextPUblishSubject.asObservable()).map { username, password in
            return username.count > 4 && password.count > 7
        }.startWith(false)
    }
}
