//
//  CheckLocationPermissionsCoordinator.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class CheckLocationPermissionsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let window: UIWindow?
    private weak var delegate: AppCoordinatorDelegate?

    init(window: UIWindow?, delegate: AppCoordinatorDelegate?) {
        self.window = window
        self.delegate = delegate
    }

    func start() {
        let viewModel = CheckLocationPermissionsViewModel(navigator: self)
        let vc = CheckLocationPermissionsViewController(viewModel: viewModel)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }

    func finish() {}
}

extension CheckLocationPermissionsCoordinator: CheckLocationPermissionsNavigator {
    func didGetLocationPermissions() {
        delegate?.didGetLocationPermissions(from: self)
        finish()
    }

    func didSelectShowCityList() {
        delegate?.didSelectCityList(from: self)
        finish()
    }
}
