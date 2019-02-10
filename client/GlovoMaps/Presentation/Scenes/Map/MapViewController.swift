//
//  MapViewController.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    private var mapView: GMSMapView!
    private var cities = [CityViewEntity]()

    typealias CityCode = String
    private var cityCenterMap = [CityCode: CLLocationCoordinate2D]()

    private var currentZoom: Float = 14
    private let markerZoom: Float = 9

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 41.38, longitude: 2.17, zoom: currentZoom)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    func display(_ cities: [CityViewEntity]) {
        self.cities = cities
        displayAllCitiesWithCurrentZoom()
    }

    private func displayAllCitiesWithCurrentZoom() {
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
        guard let encodedPath = city.workingArea?.first, let path = GMSPath(fromEncodedPath: encodedPath) else { return nil }

        let position = path.coordinate(at: 0)
        let marker = GMSMarker(position: position)
        marker.map = mapView
        return position
    }

    private func centerMap(on marker: GMSMarker) {
        guard let cityCode = cityCenterMap.first(where: { $0.value == marker.position })?.key else { return }
        guard let city = cities.first(where: { $0.code == cityCode }) else { return }
        let paths = getPaths(for: city)
        let bounds = getBounds(for: paths)
        let cameraUpdate = GMSCameraUpdate.fit(bounds)
        mapView.animate(with: cameraUpdate)
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
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        centerMap(on: marker)
        return true
    }
}

extension CLLocationCoordinate2D {
    
}
