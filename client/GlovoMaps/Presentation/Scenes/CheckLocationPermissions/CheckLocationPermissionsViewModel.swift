//
//  CheckLocationPermissionsViewModel.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift

// MARK: - Input / Output

struct CheckLocationPermissionsInput {
    var requestLocationPermissions: AnyObserver<Void>
    var showCityList: AnyObserver<Void>
}

struct CheckLocationPermissionsOutput {
    var navigate: Observable<Void>
}

// MARK: - Navigator

protocol CheckLocationPermissionsNavigator: class {
    func didGetLocationPermissions()
    func didSelectShowCityList()
}

class CheckLocationPermissionsViewModel: ViewModel {

    let input: CheckLocationPermissionsInput
    let output: CheckLocationPermissionsOutput

    private let requestLocationPermissionsSubject = PublishSubject<Void>()
    private let showCityListSubject = PublishSubject<Void>()

    init(navigator: CheckLocationPermissionsNavigator) {
        let navigateToRequestPermissions = requestLocationPermissionsSubject
            .flatMap { _ in
                return LocationManager.shared.requestPermissions().asObservable().map({ _ in Void() })
        }

        let isAuthorized = LocationManager.shared.isAuthorized()
            .filter({ $0 })
        let locations = LocationManager.shared.getLocation()
            .filter { $0 != nil }
            .map { $0! }
            .take(1)

        let navigateToMap = Observable.combineLatest(isAuthorized, locations)
            .do(onNext: { _ in
                navigator.didGetLocationPermissions()
            })
            .map({ _ in Void() })

        let navigateToCityList = showCityListSubject
            .do(onNext: { _ in
                navigator.didSelectShowCityList()
            })

        self.input = CheckLocationPermissionsInput(requestLocationPermissions: requestLocationPermissionsSubject.asObserver(),
                                                   showCityList: showCityListSubject.asObserver())
        self.output = CheckLocationPermissionsOutput(navigate: Observable.merge(navigateToRequestPermissions, navigateToMap, navigateToCityList))
    }
}
