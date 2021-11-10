//
//  ApplicationCoordinator.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 10.11.2021.
//

import Foundation

class ApplicationCoordinator: BaseCoordinator {
   
    override func start() {
       
        let realmService = RealmService()
        let user = realmService.load(User()).first(where: {
            $0.authorized == true
        })
        
        if user == nil {
            toAuth()
        } else {
            toMap()
            //window?.rootViewController = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapController") as! MapController
        }
    }
    
    private func toAuth() {
        let coordinator = AuthCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependecy(coordinator)
        coordinator.start()
    }
    
    private func toMap() {
        let coordinator = MapCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependecy(coordinator)
        coordinator.start()
    }
}
