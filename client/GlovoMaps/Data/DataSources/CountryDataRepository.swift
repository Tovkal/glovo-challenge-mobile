//
//  CountryDataRepository.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Moya
import RxSwift

class CountryDataRepository: BaseDataRepository, CountryRepository {

    func getCountries() -> Single<[Country]> {
        return provider.rx.request(MultiTarget(CountryTarget.getCountries()))
            .filterSuccessfulStatusCodes()
            .map([Country].self)
    }
}
