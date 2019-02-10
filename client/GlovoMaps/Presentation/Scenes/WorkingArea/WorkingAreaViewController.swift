//
//  WorkingAreaViewController.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import RxSwift

class WorkingAreaViewController: UIViewController {

    @IBOutlet private var cityDetailsContainer: UIView!
    @IBOutlet private var mapContainer: UIView!

    private let bag = DisposeBag()
    private let viewModel: WorkingAreaViewModel
    private let cityDetailsViewController: CityDetailsViewController
    private let mapViewController: MapViewController

    init(viewModel: WorkingAreaViewModel,
         cityDetailsViewController: CityDetailsViewController,
         mapViewController: MapViewController) {
        self.viewModel = viewModel
        self.cityDetailsViewController = cityDetailsViewController
        self.mapViewController = mapViewController
        super.init(nibName: "WorkingArea", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        embedChild(cityDetailsViewController, in: cityDetailsContainer)
        embedChild(mapViewController, in: mapContainer)

        bindUI()
    }

    private func bindUI() {
        viewModel.output.cities.subscribe(onNext: { (cities) in
            self.mapViewController.display(cities)
        }).disposed(by: bag)
    }

    func centerOnCity(with code: String) {
        mapViewController.centerOnCity(with: code)
    }
}
