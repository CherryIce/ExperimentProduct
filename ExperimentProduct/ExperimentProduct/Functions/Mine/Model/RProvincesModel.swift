//
//  RProvincesModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/10.
//

import UIKit
import HandyJSON

class RProvincesModel: RPAreaModel {
    var cities = RPCitysModel()
    required init() {}
}

class RPCitysModel: HandyJSON {
    var city = [RPCityModel]()
    required init() {}
}

class RPCityModel: RPAreaModel {
    var areas = RPAreasModel()
    required init() {}
}


class RPAreasModel: HandyJSON {
    var area = [RPAreaModel]()
    required init() {}
}

class RPAreaModel: HandyJSON {
    var ssqid = ""
    var ssqname = ""
    var ssqename = ""
    required init() {}
}
