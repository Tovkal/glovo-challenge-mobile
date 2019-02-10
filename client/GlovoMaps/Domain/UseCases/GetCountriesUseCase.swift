//
//  GetCountriesUseCase.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

class GetCountriesUseCase {

    private let countryRepository: CountryRepository
    private let cityRepository: CityRepository

    init(countryRepository: CountryRepository,
         cityRepository: CityRepository) {
        self.countryRepository = countryRepository
        self.cityRepository = cityRepository
    }

    func getCountries() -> Single<[CountryViewEntity]> {
        return Single.zip(countryRepository.getCountries(), cityRepository.getCities()) { (countries, cities) -> [CountryViewEntity] in
            let sortedCountries = countries.sorted(by: { $0.name < $1.name })
            let sortedCities = cities.sorted(by: { $0.name < $1.name })
            var result = [CountryViewEntity]()

            sortedCountries.forEach({ country in
                let cities = sortedCities
                    .filter({ $0.countryCode == country.code })
                    .map { CityViewEntity(name: $0.name, code: $0.code) }
                let country = CountryViewEntity(name: country.name, items: cities)
                result.append(country)
            })

            return result
        }
    }
}
