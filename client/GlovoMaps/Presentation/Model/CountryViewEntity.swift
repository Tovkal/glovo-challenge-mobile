//
//  CountryViewEntity.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxDataSources

struct CountryViewEntity {
    var name: String
    var items: [CityViewEntity]
}

extension CountryViewEntity: SectionModelType {
    typealias Item = CityViewEntity

    init(original: CountryViewEntity, items: [CityViewEntity]) {
        self = original
        self.items = items
    }
}
