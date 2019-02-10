//
//  ViewModel.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 09/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

protocol ViewModel: class {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
