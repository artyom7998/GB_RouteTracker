//
//  RegistrationController.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 10.11.2021.
//

import UIKit

class RegistrationController: UIViewController {
    
    private let realmService = RealmService()
    
    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    @IBAction func registration(_ sender: Any) {
        guard let login = loginView.text,
              let password = passwordView.text else { return }
        
        let user = User()
        user.login = login
        user.password = password
        
        var createSuccess = true
        
        do {
            try realmService.save(items: [user])
        } catch {
            print(error)
            createSuccess = false
        }
        
        if createSuccess {
            showAlert("Успешная регистрации", "Вы можете авторизоваться")
        } else {
            showAlert("Ошибка", "Произошла ошибка при регистрации. Попробуйте еще раз")
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Oк", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
