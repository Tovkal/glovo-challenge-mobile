//
//  CityDataRepository.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Moya
import RxSwift

class CityDataRepository: BaseDataRepository, CityRepository {

    func getCities() -> Single<[City]> {
        return provider.rx.request(MultiTarget(CityTarget.getCities()))
            .filterSuccessfulStatusCodes()
            .map([City].self)
    }

    func getCity(for code: String) -> Single<City> {
        return provider.rx.request(MultiTarget(CityTarget.getCity(code: code)))
            .filterSuccessfulStatusCodes()
            .map(City.self)
    }
}
