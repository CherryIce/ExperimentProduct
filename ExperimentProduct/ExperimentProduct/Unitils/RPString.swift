//
//  RPString.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/16.
//

import UIKit
import CommonCrypto

public extension String {
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        return hash as String
    }
    
    //字符串转date
    func toDate(_ dateFormat:String) -> Date {
        if count == 0 {
            log.debug("字符串为空")
            return Date.init()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: self) else {
            log.debug(self+" 转date失败了")
            return Date.init()
        }
        return date
    }
    
    //字符串转时间戳
    func toTimeInterval(_ dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        if self.isEmpty {
            return ""
        }
        return String(self.toDate(dateFormat).timeIntervalSince1970)
    }
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
                                                                .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
