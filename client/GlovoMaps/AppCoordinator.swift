//
//  AppCoordinator.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let coordinator = CheckLocationPermissionsCoordinator(window: window, delegate: self)
        addChildCoordinator(coordinator)
        coordinator.start()
    }

    func finish() {}

    private func showMap() {
        showMap(for: nil)
    }

    private func showMap(for cityCode: String?) {
        // TODO
    }

    private func showCityList() {
        let coordinator = CityListCoordinator(delegate: self)
        addChildCoordinator(coordinator)
        coordinator.start()
        window?.rootViewController = coordinator.rootViewController
    }
}

protocol AppCoordinatorDelegate: class {
    func didGetLocationPermissions(from coordinator: Coordinator)
    func didSelectCityList(from coordinator: Coordinator)
    func didSelectCity(with code: String, from coordinator: Coordinator)
}

extension AppCoordinator: AppCoordinatorDelegate {
    func didGetLocationPermissions(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showMap()
    }

    func didSelectCityList(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showCityList()
    }

    func didSelectCity(with code: String, from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showMap(for: code)
    }
}
