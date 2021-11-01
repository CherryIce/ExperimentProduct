//
//  RPCache.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/1.
//

import UIKit
import YYCache

//use RPCache just fixed a warning log about yycache lock
class RPCache: NSObject {
    static let shared = RPCache()
    var cache:YYCache?
    
    override init() {
        let cache = YYCache.init(name: "/RPCache")
        self.cache = cache
    }
}
