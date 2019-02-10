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
    private let parent = UINavigationController()

    init(window: UIWindow?) {
        self.window = window
        window?.rootViewController = parent
        window?.makeKeyAndVisible()
    }

    func start() {
        if LocationManager.shared.isAuthorized() {
            showMap()
        } else {
            showCheckLocationPermissions()
        }
    }

    func finish() {}

    private func showCheckLocationPermissions() {
        let coordinator = CheckLocationPermissionsCoordinator(parentViewController: parent, delegate: self)
        addChildCoordinator(coordinator)
        coordinator.start()
    }

    private func showMap() {
        showMap(for: nil)
    }

    private func showMap(for cityCode: String?) {
        let coordinator = MainCoordinator(for: cityCode, parentViewController: parent)
        addChildCoordinator(coordinator)
        coordinator.start()
    }

    private func showCityList() {
        let coordinator = CityListCoordinator(delegate: self, parentViewController: parent)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}

protocol AppCoordinatorDelegate: class {
    func didGetLocationPermissions(from coordinator: Coordinator)
    func didSelectCityList(from coordinator: Coordinator)
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
}

extension AppCoordinator: CityListDelegate {
    func didSelectCity(with code: String, from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showMap(for: code)
    }
}
