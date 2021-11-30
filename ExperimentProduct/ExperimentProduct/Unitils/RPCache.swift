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
        cache?.diskCache.countLimit = 10000
        cache?.memoryCache.countLimit = 10000
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
            log.debug("Unsupport Content-Type Filter reviced URL"+(url?.absoluteString)!+contentType!)
            return false
        }
    }
    
    func removeAllCache() {
        //unable to close due to unfinalized statements or unfinished backups
        self.cache?.removeAllObjects()
        KTVHTTPCache.cacheDeleteAllCaches()
    }
    
    func calculateCacheSize() -> String? {
        let yy_diskCache = self.cache?.diskCache.totalCost()
        let ktv_cache = KTVHTTPCache.cacheTotalCacheLength()
        let total:Float = Float(Float(yy_diskCache ?? 0)+Float(ktv_cache))
        var sizeText:String?
        if total >= pow(10, 9) {
            sizeText = String(format: "%.2fGB", total / pow(10, 9))
        } else if (total >= pow(10, 6)) {
            sizeText = String(format: "%.2fMB", total / pow(10, 6))
        }else if (total >= pow(10, 3)) {
            sizeText = String(format: "%.2fKB", total / pow(10, 3))
        }else{
            sizeText = String(format: "%lluB", total)
        }
        return sizeText
    }
}
