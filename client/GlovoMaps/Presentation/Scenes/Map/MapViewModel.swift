//
//  MapViewModel.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

// MARK: - Input / Output

struct MapInput {
    var cityInCenterOfMap: AnyObserver<CityViewEntity?>
}

struct MapOutput {
}

class MapViewModel: ViewModel {

    let input: MapInput
    let output: MapOutput

    init(cityInCenterOfMap: AnyObserver<CityViewEntity?>) {

        self.input = MapInput(cityInCenterOfMap: cityInCenterOfMap)
        self.output = MapOutput()
    }
}
