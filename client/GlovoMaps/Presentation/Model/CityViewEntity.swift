//
//  CityViewEntity.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct CityViewEntity: Equatable {
    let name: String
    let code: String

    let countryCode: String?
    let workingArea: [String]?
    let busy: Bool?
    let currency: String?
    let enabled: Bool?
    let languageCode: String?
    let timeZone: String?
}

extension CityViewEntity {
    init(name: String, code: String) {
        self.init(name: name,
                  code: code,
                  countryCode: nil,
                  workingArea: nil,
                  busy: nil,
                  currency: nil,
                  enabled: nil,
                  languageCode: nil,
                  timeZone: nil)
    }
}
