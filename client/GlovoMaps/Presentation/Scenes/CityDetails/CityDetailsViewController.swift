//
//  CityDetailsViewController.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityDetailsViewController: UIViewController {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var codeLabel: UILabel!
    @IBOutlet private var countryCodeLabel: UILabel!
    @IBOutlet private var busyLabel: UILabel!
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var enabledLabel: UILabel!
    @IBOutlet private var languageCodeLabel: UILabel!
    @IBOutlet private var timezoneLabel: UILabel!

    private let bag = DisposeBag()
    private let viewModel: CityDetailsViewModel

    init(viewModel: CityDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CityDetails", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    private func bindUI() {
        viewModel.output.cityDetails
            .asDriver(onErrorRecover: { (error) -> SharedSequence<DriverSharingStrategy, CityViewEntity?> in
                let alert = UIAlertController.createAlert(for: error)
                self.present(alert, animated: true, completion: nil)
                return Driver.just(nil)
            })
            .distinctUntilChanged({ $0 == $1 })
            .drive(onNext: { [weak self] city in
                self?.updateCityDetails(with: city)
            }).disposed(by: bag)
    }

    private func updateCityDetails(with city: CityViewEntity?) {
        nameLabel.text = city?.name ?? "???"
        codeLabel.text = city?.code ?? "???"
        countryCodeLabel.text = city?.countryCode ?? "???"
        setBooleanLabelValue(label: busyLabel, value: city?.busy)
        currencyLabel.text = city?.currency ?? "???"
        setBooleanLabelValue(label: enabledLabel, value: city?.enabled)
        languageCodeLabel.text = city?.languageCode ?? "???"
        timezoneLabel.text = city?.timeZone ?? "???"
    }

    private func setBooleanLabelValue(label: UILabel, value: Bool?) {
        if let value = value {
            label.text = value ? "labels.common.yes".localized : "labels.common.no".localized
        } else {
            label.text = "???"
        }
    }
}
