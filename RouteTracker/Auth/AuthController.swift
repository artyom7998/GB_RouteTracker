//
//  AuthController.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 10.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

class AuthController: UIViewController {
    
    var toRegistration: (() -> Void)?
    var toRestorePassword: (() -> Void)?
    var toMap: (() -> Void)?
    
    private let realmService = RealmService()
    
    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(_ sedner: UIButton) {
        guard let login = loginView.text,
              let password = passwordView.text else { return }
        
        let user = realmService.load(User()).first(where: {
            $0.login == login && $0.password == password
        })
        
        if user != nil {
            if updateUsers(true, user) {
                toMap?()
            } else {
                showAlert("Ошибка", "Произошла ошибка авторизации")
            }
        } else {
            showAlert("Ошибка", "Введен неверный логин или пароль")
        }
    }
    
    @IBAction func registration(_ sender: Any) {
        toRegistration?()
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Oк", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func updateUsers(_ resetAuthUsers: Bool, _ authorizeUser: User?) -> Bool {
        
        guard let realm = realmService.getRealm() else { return false}
    
        var users = [User()]
        
        if resetAuthUsers {
            users = realmService.load(User()).filter { User in
                User.authorized
            }
            
            users.forEach { User in
                try! realm.write {
                    User.authorized = false
                }
            }
        }
        
        if let user = authorizeUser {
            try! realm.write {
                user.authorized = true
            }
        }
        
        return true
    }
    
    private func configurungLoginBinding() {
        Observable
            .combineLatest(loginView.rx.text, passwordView.rx.text)
            .map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 6
            }
            .bind { [weak loginButton] inputFilled in
                loginButton?.isEnabled = inputFilled
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurungLoginBinding()
    }
}
