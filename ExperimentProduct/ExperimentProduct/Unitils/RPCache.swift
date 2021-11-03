//
//  RPCache.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/1.
//

import UIKit
import YYCache
import KTVHTTPCache

//use RPCache just fixed a warning log about yycache lock
class RPCache: NSObject {
    static let shared = RPCache()
    var cache:YYCache?
    
    override init() {
        let cache = YYCache.init(name: "/RPCache")
//        cache?.diskCache.countLimit = 1000
//        cache?.memoryCache.countLimit = 1000
        self.cache = cache
        
        KTVHTTPCache.logSetRecordLogEnable(true)
        try! KTVHTTPCache.proxyStart()
//        try? KTVHTTPCache.proxyStart()
        KTVHTTPCache.cacheSetMaxCacheLength(500 * 1024 * 1024)//500M
        KTVHTTPCache.encodeSetURLConverter { (URL) -> URL? in
            return URL
        }
        
        KTVHTTPCache.downloadSetTimeoutInterval(30)
        KTVHTTPCache.downloadSetUnacceptableContentTypeDisposer { (url, contentType) -> Bool in
            log.warning("Unsupport Content-Type Filter reviced URL"+(url?.absoluteString)!+contentType!)
            return false
        }
    }
    
    func removeAllCache() {
        self.cache?.removeAllObjects()
        KTVHTTPCache.cacheDeleteAllCaches()
    }
}
