//
//  BaseDataRepository.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Moya

class BaseDataRepository {

    let provider: MoyaProvider<MultiTarget>

    init() {
        self.provider = MoyaProvider<MultiTarget>()
    }
}
