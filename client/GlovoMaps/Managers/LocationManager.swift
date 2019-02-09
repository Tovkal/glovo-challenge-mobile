//
//  LocationManager.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class LocationManager {

    static let shared = LocationManager()

    private static let validStatus: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]
    private let locationManager = CLLocationManager()

    private init() {}

    func hasLocationPermissions() -> Single<Bool> {
        return Single.create(subscribe: { (single) -> Disposable in
            let status = CLLocationManager.authorizationStatus()
            single(.success(LocationManager.validStatus.contains(status)))
            return Disposables.create()
        })
    }

    func requestPermissions() -> Completable {
        return Completable.create(subscribe: { (completable) -> Disposable in
            self.locationManager.requestWhenInUseAuthorization()
            completable(.completed)
            return Disposables.create()
        })
    }

    func isAuthorized() -> Observable<Bool> {
        return locationManager.rx.didChangeAuthorization.map({ LocationManager.validStatus.contains($1) })
    }
}
