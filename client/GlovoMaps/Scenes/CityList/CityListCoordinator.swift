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

    func start() {
        
    }

    func finish() {}
}
