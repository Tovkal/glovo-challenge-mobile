//
//  CityListCoordinator.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol CityListDelegate: class {
    func didSelectCity(with code: String, from coordinator: Coordinator)
}

class CityListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let useCase = GetCountriesUseCase(countryRepository: CountryDataRepository(), cityRepository: CityDataRepository())
    private weak var delegate: CityListDelegate?
    private weak var parent: UINavigationController?

    init(delegate: CityListDelegate?, parentViewController: UINavigationController?) {
        self.delegate = delegate
        self.parent = parentViewController
    }

    func start() {
        let viewModel = CityListViewModel(getCountriesUseCase: useCase, navigator: self)
        let viewController = CityListViewController(viewModel: viewModel)
        parent?.pushViewController(viewController, animated: true)
    }

    func finish() {}
}

extension CityListCoordinator: CityListViewNavigator {
    func didSelectCity(code: String) {
        delegate?.didSelectCity(with: code, from: self)
        finish()
    }
}
