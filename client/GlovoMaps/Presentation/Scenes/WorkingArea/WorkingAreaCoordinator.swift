//
//  WorkingAreaCoordinator.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class WorkingAreaCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let getCitiesUseCase = GetCitiesUseCase(repository: CityDataRepository())

    var rootViewController: UIViewController {
        return navigationController
    }

    private let navigationController = UINavigationController()

    init(for cityCode: String?) {

    }

    func start() {
        let cityDetailsViewModel = CityDetailsViewModel(getCitiesUseCase: getCitiesUseCase)
        let cityDetailsViewController = CityDetailsViewController(viewModel: cityDetailsViewModel)

        let mapViewModel = MapViewModel(cityInCenterOfMap: cityDetailsViewModel.input.city)
        let mapViewController = MapViewController(viewModel: mapViewModel)

        let mainViewModel = WorkingAreaViewModel(locationCityCode: "?????", getCitiesUseCase: getCitiesUseCase)
        let mainVC = WorkingAreaViewController(viewModel: mainViewModel, cityDetailsViewController: cityDetailsViewController, mapViewController: mapViewController)

        navigationController.pushViewController(mainVC, animated: true)
    }

    func finish() {}
}
