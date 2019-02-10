//
//  CityDetailsViewModel.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

// MARK: - Input / Output

struct CityDetailsInput {
    var city: AnyObserver<CityViewEntity?>
}

struct CityDetailsOutput {
    var cityDetails: Observable<CityViewEntity?>
}

class CityDetailsViewModel: ViewModel {

    let input: CityDetailsInput
    let output: CityDetailsOutput

    private let citySubject = PublishSubject<CityViewEntity?>()

    init(getCitiesUseCase: GetCitiesUseCase) {

        let cityDetails = citySubject.flatMap { (city) -> Observable<CityViewEntity?> in
            if let city = city {
                return getCitiesUseCase.getCity(for: city.code).map({ Optional($0) }).asObservable()
            } else {
                return Observable.just(nil)
            }
        }

        self.input = CityDetailsInput(city: citySubject.asObserver())
        self.output = CityDetailsOutput(cityDetails: cityDetails)
    }
}
