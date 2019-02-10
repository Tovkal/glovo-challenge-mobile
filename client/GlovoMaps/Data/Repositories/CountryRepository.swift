//
//  CountryRepository.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

protocol CountryRepository {
    func getCountries() -> Single<[Country]>
}
