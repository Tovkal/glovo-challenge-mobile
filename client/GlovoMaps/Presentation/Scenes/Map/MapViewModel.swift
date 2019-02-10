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
    var locationOutsideCity: AnyObserver<Void>
}

struct MapOutput {
    var navigate: Observable<Void>
}

class MapViewModel: ViewModel {

    let input: MapInput
    let output: MapOutput

    private let locationOutsideCitySubject = PublishSubject<Void>()

    init(cityInCenterOfMap: AnyObserver<CityViewEntity?>, navigator: MapNavigator) {

        let navigate = locationOutsideCitySubject.do(onNext: { _ in
            navigator.locationOutsideCity()
        })

        self.input = MapInput(cityInCenterOfMap: cityInCenterOfMap, locationOutsideCity: locationOutsideCitySubject.asObserver())
        self.output = MapOutput(navigate: navigate)
    }
}
