//
//  WorkingAreaCoordinator.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

// MARK: - MapNavigator

protocol MapNavigator: class {
    func locationOutsideCity()
}

class WorkingAreaCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let getCitiesUseCase = GetCitiesUseCase(repository: CityDataRepository())

    private weak var parent: UINavigationController?

    init(for cityCode: String?, parentViewController: UINavigationController) {
        self.parent = parentViewController
    }

    func start() {
        let cityDetailsViewModel = CityDetailsViewModel(getCitiesUseCase: getCitiesUseCase)
        let cityDetailsViewController = CityDetailsViewController(viewModel: cityDetailsViewModel)

        let mapViewModel = MapViewModel(cityInCenterOfMap: cityDetailsViewModel.input.city,
                                        navigator: self)
        let mapViewController = MapViewController(viewModel: mapViewModel)

        let mainViewModel = WorkingAreaViewModel(locationCityCode: "?????", getCitiesUseCase: getCitiesUseCase)
        let mainVC = WorkingAreaViewController(viewModel: mainViewModel, cityDetailsViewController: cityDetailsViewController, mapViewController: mapViewController)

        parent?.setViewControllers([mainVC], animated: true)
    }

    func finish() {}
}

extension WorkingAreaCoordinator: MapNavigator {
    func locationOutsideCity() {
        let coordinator = CityListCoordinator(delegate: self, parentViewController: parent)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}

extension WorkingAreaCoordinator: CityListDelegate {
    func didSelectCity(with code: String, from coordinator: Coordinator) {
        parent?.popViewController(animated: true)
        removeChildCoordinator(coordinator)
    }
}
