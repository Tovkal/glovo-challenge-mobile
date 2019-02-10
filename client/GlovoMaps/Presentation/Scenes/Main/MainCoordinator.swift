//
//  MainCoordinator.swift
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

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let getCitiesUseCase = GetCitiesUseCase(repository: CityDataRepository())

    private var cityCode: String?
    private weak var parent: UINavigationController?
    private var mainViewController: MainViewController?

    init(for cityCode: String?, parentViewController: UINavigationController) {
        self.cityCode = cityCode
        self.parent = parentViewController
    }

    func start() {
        let cityDetailsViewModel = CityDetailsViewModel(getCitiesUseCase: getCitiesUseCase)
        let cityDetailsViewController = CityDetailsViewController(viewModel: cityDetailsViewModel)

        let mapViewModel = MapViewModel(cityInCenterOfMap: cityDetailsViewModel.input.city,
                                        navigator: self)
        let mapViewController = MapViewController(viewModel: mapViewModel, cityCode: cityCode)

        let mainViewModel = MainViewModel(locationCityCode: "?????", getCitiesUseCase: getCitiesUseCase)
        let mainVC = MainViewController(viewModel: mainViewModel,
                                               cityDetailsViewController: cityDetailsViewController,
                                               mapViewController: mapViewController)
        mainViewController = mainVC

        parent?.setViewControllers([mainVC], animated: true)
    }

    func finish() {}
}

extension MainCoordinator: MapNavigator {
    func locationOutsideCity() {
        let coordinator = CityListCoordinator(delegate: self, parentViewController: parent)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}

extension MainCoordinator: CityListDelegate {
    func didSelectCity(with code: String, from coordinator: Coordinator) {
        parent?.popViewController(animated: true)
        removeChildCoordinator(coordinator)
        mainViewController?.centerOnCity(with: code)
    }
}
