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

class LocationManager: NSObject {

    static let shared = LocationManager()

    private static let validStatus: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]
    private let locationManager = CLLocationManager()
    private let bag = DisposeBag()

    private let lastLocation = BehaviorSubject<CLLocation?>(value: nil)

    private override init() {
        super.init()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.rx.location.bind(to: lastLocation).disposed(by: bag)
    }

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

    func isAuthorized() -> Bool {
        return LocationManager.validStatus.contains(CLLocationManager.authorizationStatus())
    }

    func isAuthorized() -> Observable<Bool> {
        return locationManager.rx.didChangeAuthorization.map({ LocationManager.validStatus.contains($1) })
    }

    func getLocation() -> Observable<CLLocation?> {
        return locationManager.rx.location
    }

    func getLastPosition() -> CLLocation? {
        do {
            return try lastLocation.value()
        } catch {
            return nil
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if LocationManager.validStatus.contains(status) {
            locationManager.startUpdatingLocation()
        }
    }
}
