//
//  CityListViewModel.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - Input / Output

struct CityListInput {
    var selectedCity: AnyObserver<CityViewEntity>
}

struct CityListOutput {
    var items: Observable<[CountryViewEntity]>
    var isLoading: Observable<Bool>
    var navigate: Observable<Void>
}

// MARK: - Navigator

protocol CityListViewNavigator: class {
    func didSelectCity(code: String)
}

class CityListViewModel: ViewModel {

    let input: CityListInput
    let output: CityListOutput

    private let selectedCitySubject = PublishSubject<CityViewEntity>()

    init(getCountriesUseCase: GetCountriesUseCase, navigator: CityListViewNavigator) {
        let isLoading = BehaviorSubject<Bool>(value: false)

        let navigateToCity = selectedCitySubject.do(onNext: { (city) in
            navigator.didSelectCity(code: city.code)
        })
        .map({ _ in Void() })

        let items = getCountriesUseCase.getCountries()
            .asObservable()
            .do(onNext: { _ in
                isLoading.onNext(false)
            }, onSubscribe: {
                isLoading.onNext(true)
            })

        self.input = CityListInput(selectedCity: selectedCitySubject.asObserver())
        self.output = CityListOutput(items: items, isLoading: isLoading.asObservable(),
                                     navigate: navigateToCity)
    }
}
