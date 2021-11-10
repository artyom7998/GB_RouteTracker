//
//  AuthCoordinator.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 10.11.2021.
//
import UIKit

final class AuthCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showAuthModule()
    }
    
    private func showAuthModule() {
        
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .initViewContoller(AuthController.self)
        
        controller.toMap = { [weak self] in
           // self?.showMapModule()
            self?.onFinishFlow?()
        }
        
        controller.toRegistration = { [weak self] in
            self?.showRegistrationModule()
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showMapModule() {
        let controller = UIStoryboard(name: "Map", bundle: nil)
            .initViewContoller(MapController.self)
        
        //rootController?.pushViewController(controller, animated: true)
    }
    
    private func showRegistrationModule() {
        let controller = UIStoryboard(name: "Registration", bundle: nil)
            .initViewContoller(RegistrationController.self)
        
        rootController?.pushViewController(controller, animated: true)
    }
}
