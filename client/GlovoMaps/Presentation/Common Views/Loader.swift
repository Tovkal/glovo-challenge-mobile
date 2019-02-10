//
//  Loader.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import SnapKit

class Loader: UIView {

    private lazy var activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configView() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.5)

        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true

        activityIndicator.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.snp.makeConstraints { (make) in
            make.height.equalTo(75)
            make.width.equalTo(75)
        }
    }

    func animate(_ animate: Bool) {
        if animate {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        isHidden = !animate
    }
}
