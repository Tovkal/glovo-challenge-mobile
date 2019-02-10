//
//  CheckLocationPermissionsViewController.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckLocationPermissionsViewController: UIViewController {

    @IBOutlet private var shareLocationButton: UIButton!
    @IBOutlet private var showCityListButton: UIButton!

    private let viewModel: CheckLocationPermissionsViewModel
    private let bag = DisposeBag()

    init(viewModel: CheckLocationPermissionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CheckLocationPermissions", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    private func bindUI() {
        shareLocationButton.rx.tap.bind(to: viewModel.input.requestLocationPermissions).disposed(by: bag)
        showCityListButton.rx.tap.bind(to: viewModel.input.showCityList).disposed(by: bag)

        viewModel.output.navigate.subscribe().disposed(by: bag)
    }
}
