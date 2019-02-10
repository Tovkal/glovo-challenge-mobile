//
//  City.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct City: Codable {
    let code: String
    let countryCode: String
    let name: String
    let workingArea: [String]

    let busy: Bool?
    let currency: String?
    let enabled: Bool?
    let languageCode: String?
    let timeZone: String?

    enum CodingKeys: String, CodingKey {
        case busy, code, name
        case countryCode = "country_code"
        case currency, enabled
        case languageCode = "language_code"
        case timeZone = "time_zone"
        case workingArea = "working_area"
    }
}
