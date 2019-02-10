//
//  MainViewModel.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

// MARK: - Input / Output

struct MainInput {
}

struct MainOutput {
    var cities: Observable<[CityViewEntity]>
}

class MainViewModel: ViewModel {

    let input: MainInput
    let output: MainOutput

    init(locationCityCode: String?, getCitiesUseCase: GetCitiesUseCase) {

        let cities = getCitiesUseCase.getCities().asObservable()

        self.input = MainInput()
        self.output = MainOutput(cities: cities)
    }
}
