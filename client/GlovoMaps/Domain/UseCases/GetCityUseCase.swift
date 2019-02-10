//
//  GetCityUseCase.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

class GetCityUseCase {

    private let repository: CityRepository

    init(repository: CityRepository) {
        self.repository = repository
    }

    func getCity(for code: String) -> Single<CityViewEntity> {
        return repository.getCity(for: code).map {
            CityViewEntity.init(name: $0.name,
                                code: $0.code,
                                countryCode: $0.countryCode,
                                workingArea: $0.workingArea,
                                busy: $0.busy,
                                currency: $0.currency,
                                enabled: $0.enabled,
                                languageCode: $0.languageCode,
                                timeZone: $0.timeZone)
        }
    }
}
