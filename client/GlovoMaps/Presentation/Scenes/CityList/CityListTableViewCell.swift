//
//  CityListTableViewCell.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import SnapKit

class CityListTableViewCell: UITableViewCell {

    private lazy var cityNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        addSubview(cityNameLabel)
        accessoryType = .disclosureIndicator

        cityNameLabel.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
    }

    func configure(with city: CityViewEntity) {
        cityNameLabel.text = city.name
    }
}
