//
//  Localizable.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

public protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized
    }
}

extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(titleLabel?.text?.localized, for: .normal)
    }
}

extension UIBarButtonItem {
    open override func awakeFromNib() {
        super.awakeFromNib()
        title = title?.localized
    }
}

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        placeholder = placeholder?.localized
        text = text?.localized
    }
}

extension UITabBarItem {
    open override func awakeFromNib() {
        super.awakeFromNib()
        title = title?.localized
    }
}

