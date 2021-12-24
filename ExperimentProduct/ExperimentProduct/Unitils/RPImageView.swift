//
//  RPImageView.swift
//  ExperimentProduct
//
//  Created by hunin on 2021/12/17.
//

import UIKit
import AsyncDisplayKit

class RPImageView: ASNetworkImageNode {
    
}

extension ASNetworkImageNode {
    static func imageNode() -> ASNetworkImageNode {
        let manager = RPCache.shared
        return ASNetworkImageNode(cache: manager, downloader: manager)
    }
}

//em... 配置好像出了点问题
extension RPCache: ASImageCacheProtocol, ASImageDownloaderProtocol {
    //下载这里需要多做些特殊处理,不然大量图片初次加载还是容易卡顿
    //This method is likely to be called on the main thread, so any custom implementations should make sure to background any expensive download operations.
    func downloadImage(with URL: URL,
                       shouldRetry: Bool,
                       callbackQueue: DispatchQueue,
                       downloadProgress: ASImageDownloaderProgress?,
                       completion: @escaping ASImageDownloaderCompletion) -> Any? {
        //可以参考ASBasicImageDownloader的后台下载处理。。。😭😭😭 先留着
        let task: Void = URLSession.shared.dataTask(with: URL, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async {
                    completion(nil,error,nil,nil)
                }
            }
            if URL.absoluteString.contains("webp") {
                DispatchQueue.global().async {
                    if let data = data, let image = UIImage.imageWithWebPData(imageData: data) {
                        DispatchQueue.main.async {
                            self.cache?.setObject(image, forKey: URL.absoluteString)
                            completion(image,error,nil,nil)
                        }
                    }
                }
            }else{
                DispatchQueue.global().async {
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.cache?.setObject(image, forKey: URL.absoluteString)
                            completion(image,error,nil,nil)
                        }
                    }
                }
            }
            URLSession.shared.finishTasksAndInvalidate()
        }).resume()
        return task
    }
    
    public func cancelImageDownload(forIdentifier downloadIdentifier: Any) {
        guard let task = downloadIdentifier as? URLSessionDataTask else {
            return
        }
        task.cancel()
    }
    
    public func cachedImage(with URL: URL,
                            callbackQueue: DispatchQueue,
                            completion: @escaping AsyncDisplayKit.ASImageCacherCompletion) {
        let key = URL.absoluteString
        guard let image = self.cache?.object(forKey: key) else {
            log.debug(key)
            completion(nil, ASImageCacheType.synchronous)
            return
        }
        DispatchQueue.main.async {
            completion(image as? ASImageContainerProtocol,ASImageCacheType.synchronous)
        }
    }
    
//    func synchronouslyFetchedCachedImage(with URL: URL) -> ASImageContainerProtocol? {
//
//    }
    
    //这个鬼方法会自动清除缓存 刚缓存一会 刷一下就清除了 😂😂
//    func clearFetchedImageFromCache(with URL: URL) {
//        self.cache?.removeObject(forKey: URL.absoluteString)
//    }
}
