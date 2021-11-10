//
//  MapCoordinator.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 10.11.2021.
//

import UIKit

final class MapCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMapModule()
    }
    
    private func showMapModule() {
        let controller = UIStoryboard(name: "Map", bundle: nil)
            .initViewContoller(MapController.self)
        
        controller.toAuth = { [weak self] in
            self?.onFinishFlow?()
        }

        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showAuthModule() {
        let controller = UIStoryboard(name: "Map", bundle: nil)
            .initViewContoller(MapController.self)

        rootController?.pushViewController(controller, animated: true)
    }

}
