//
//  CountryTarget.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Moya

enum CountryTarget {
    case getCountries()
}

extension CountryTarget: TargetType {
    var baseURL: URL { return ApiConstants.baseURL }

    var path: String {
        return "countries"
    }

    var method: Method {
        return .get
    }

    var headers: [String : String]? {
        return nil
    }

    var task: Task {
        return .requestPlain
    }

    var sampleData: Data {
        return "Example".data(using: .utf8)!
    }
}