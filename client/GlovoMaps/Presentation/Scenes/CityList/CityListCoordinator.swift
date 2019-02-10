//
//  CityListCoordinator.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class CityListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var rootViewController: UIViewController {
        return navigationController
    }

    private lazy var navigationController = UINavigationController()

    private let useCase = GetCountriesUseCase(countryRepository: CountryDataRepository(), cityRepository: CityDataRepository())
    private weak var delegate: AppCoordinatorDelegate?

    init(delegate: AppCoordinatorDelegate?) {
        self.delegate = delegate
    }

    func start() {
        let viewModel = CityListViewModel(getCountriesUseCase: useCase, navigator: self)
        let viewController = CityListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }

    func finish() {}
}

extension CityListCoordinator: CityListViewNavigator {
    func didSelectCity(code: String) {
        delegate?.didSelectCity(with: code, from: self)
        finish()
    }
}
