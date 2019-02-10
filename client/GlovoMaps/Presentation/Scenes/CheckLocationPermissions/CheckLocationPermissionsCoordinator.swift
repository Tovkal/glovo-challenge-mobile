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

    private let parent: UINavigationController?
    private weak var delegate: AppCoordinatorDelegate?

    init(parentViewController: UINavigationController, delegate: AppCoordinatorDelegate?) {
        self.parent = parentViewController
        self.delegate = delegate
    }

    func start() {
        let viewModel = CheckLocationPermissionsViewModel(navigator: self)
        let vc = CheckLocationPermissionsViewController(viewModel: viewModel)
        parent?.setViewControllers([vc], animated: true)
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
