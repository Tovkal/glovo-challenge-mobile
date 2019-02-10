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
    private let viewModel: WorkingAreaViewModel

    var rootViewController: UIViewController {

        return WorkingAreaViewController(viewModel: viewModel,
                                         cityDetailsViewController: cityDetailsViewController,
                                         mapViewController: mapViewController)
    }

    private var cityDetailsViewController: CityDetailsViewController {
        return CityDetailsViewController()
    }

    private var mapViewController: MapViewController {
        return MapViewController()
    }

    init(for cityCode: String?) {
        viewModel = WorkingAreaViewModel(locationCityCode: cityCode, getCitiesUseCase: getCitiesUseCase)
    }

    func start() {
    }

    func finish() {}
}

