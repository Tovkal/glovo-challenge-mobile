//
//  UIAlertController.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func createAlert(for error: Error) -> UIAlertController {
        let alert = UIAlertController(title: "labels.common.error".localized, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "main.location_outside_city.alert.action".localized, style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
}
