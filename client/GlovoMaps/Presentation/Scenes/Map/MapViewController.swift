//
//  MapViewController.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: UIViewController {

    private var mapView: GMSMapView!
    private var cities = [CityViewEntity]()

    typealias CityCode = String
    private var cityCenterMap = [CityCode: CLLocationCoordinate2D]()
    private var cityBounds = [CityCode: GMSCoordinateBounds]()

    private var currentZoom: Float = 14
    private let markerZoom: Float = 9

    private let bag = DisposeBag()
    private let viewModel: MapViewModel
    private let cityCode: String?
    private var location: CLLocationCoordinate2D?

    init(viewModel: MapViewModel, cityCode: String?) {
        self.viewModel = viewModel
        self.cityCode = cityCode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: currentZoom)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        if cityCode == nil, let location = LocationManager.shared.getLastPosition() {
            self.location = location.coordinate
        }

        bindUI()
    }

    private func bindUI() {
        viewModel.output.navigate.subscribe().disposed(by: bag)
    }

    func display(_ cities: [CityViewEntity]) {
        self.cities = cities
        cacheBounds(for: cities)
        displayAllCitiesWithCurrentZoom()

        if let cityCode = self.cityCode {
            centerOnCity(with: cityCode)
        } else if let location = self.location, isLocationInCityBounds(location) {
            let camera = GMSCameraPosition.camera(withTarget: location, zoom: 12)
            mapView.animate(to: camera)
        } else {
            showChooseCityAlert()
            return
        }

        checkIfCityInCenterOfMap(mapView.camera.target)
    }

    func centerOnCity(with code: String) {
        guard let city = cities.first(where: { $0.code == code }) else { return }
        guard let position = getCoordinate(for: city) else { return }
        let camera = GMSCameraUpdate.setTarget(position, zoom: 12)
        mapView.animate(with: camera)
    }

    private func showChooseCityAlert() {
        let alert = UIAlertController(title: "main.location_outside_city.alert.title".localized,
                                      message: "main.location_outside_city.alert.message".localized,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "main.location_outside_city.alert.action".localized, style: .default) { _ in
            self.viewModel.input.locationOutsideCity.onNext(Void())
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func isLocationInCityBounds(_ location: CLLocationCoordinate2D) -> Bool {
        return cityBounds.contains(where: { $0.value.contains(location) })
    }

    // Calculates the bounds for every city
    private func cacheBounds(for cities: [CityViewEntity]) {
        cities.forEach { (city) in
            let paths = getPaths(for: city)
            let bounds = getBounds(for: paths)
            cityBounds[city.code] = bounds
        }
    }

    private func displayAllCitiesWithCurrentZoom() {
        // Switches between markers and working areas according to the current zoom level
        if currentZoom > markerZoom {
            displayAllCitiesWorkingAreas()
        } else {
            displayAllCitiesMarkers()
        }
    }

    private func displayAllCitiesWorkingAreas() {
        mapView.clear()
        cities.forEach { displayCityWorkingArea(city: $0) }
    }

    private func displayCityWorkingArea(city: CityViewEntity) {
        let paths = getPaths(for: city)
        paths.forEach { path in
            let polygon = GMSPolygon(path: path)
            polygon.map = mapView
        }
    }

    private func displayAllCitiesMarkers() {
        mapView.clear()
        cities.forEach {
            if let position = displayCityMarker(city: $0) {
                cityCenterMap[$0.code] = position
            }
        }
    }

    private func displayCityMarker(city: CityViewEntity) -> CLLocationCoordinate2D? {
        guard let position = getCoordinate(for: city) else { return nil }
        let marker = GMSMarker(position: position)
        marker.map = mapView
        return position
    }

    private func getCoordinate(for city: CityViewEntity) -> CLLocationCoordinate2D? {
        guard let encodedPath = city.workingArea?.first, let path = GMSPath(fromEncodedPath: encodedPath) else { return nil }

        return path.coordinate(at: 0)
    }

    private func centerMap(on marker: GMSMarker) {
        guard let cityCode = cityCenterMap.first(where: { $0.value == marker.position })?.key else { return }
        guard let bounds = cityBounds[cityCode] else { return }
        let cameraUpdate = GMSCameraUpdate.fit(bounds)
        mapView.animate(with: cameraUpdate)
    }

    private func checkIfCityInCenterOfMap(_ position: CLLocationCoordinate2D) {
        if let cityCode = cityBounds.first(where: { $0.value.contains(position) })?.key,
            let city = cities.first(where: { $0.code == cityCode }) {
            viewModel.input.cityInCenterOfMap.onNext(city)
        } else {
            viewModel.input.cityInCenterOfMap.onNext(nil)
        }
    }

    // MARK: Helpers

    private func getPaths(for city: CityViewEntity) -> [GMSPath] {
        return city.workingArea?.compactMap({ GMSPath(fromEncodedPath: $0) }) ?? []
    }

    private func getBounds(for paths: [GMSPath]) -> GMSCoordinateBounds {
        var bounds = GMSCoordinateBounds()

        paths.filter { $0.count() > 0 }
            .forEach {
                for index in 0..<$0.count() {
                    bounds = bounds.includingCoordinate($0.coordinate(at: index))
                }
        }

        return bounds
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        currentZoom = position.zoom
        displayAllCitiesWithCurrentZoom()
        checkIfCityInCenterOfMap(position.target)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        centerMap(on: marker)
        return true
    }
}
