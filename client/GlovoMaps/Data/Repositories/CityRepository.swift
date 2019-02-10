//
//  CityRepository.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

protocol CityRepository {
    func getCities() -> Single<[City]>
    func getCity(for code: String) -> Single<City>
}
