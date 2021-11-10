//
//  BaseCoordinator.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 10.11.2021.
//

import Foundation
import UIKit

class BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []
    
    func start() {}
    
    func addDependecy(_ coordinator: BaseCoordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: BaseCoordinator?) {
        guard !childCoordinators.isEmpty, let coordinator = coordinator else { return }
        
        for (index, element) in childCoordinators.reversed().enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    func setAsRoot(_ controller: UIViewController) {
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        scene?.window?.rootViewController = controller
    }
}
