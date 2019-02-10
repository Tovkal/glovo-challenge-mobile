//
//  WorkingAreaViewModel.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

// MARK: - Input / Output

struct WorkingAreaInput {
}

struct WorkingAreaOutput {
    var cities: Observable<[CityViewEntity]>
}

class WorkingAreaViewModel: ViewModel {

    let input: WorkingAreaInput
    let output: WorkingAreaOutput

    init(locationCityCode: String?, getCitiesUseCase: GetCitiesUseCase) {

        let cities = getCitiesUseCase.getCities().asObservable()

        self.input = WorkingAreaInput()
        self.output = WorkingAreaOutput(cities: cities)
    }
}
