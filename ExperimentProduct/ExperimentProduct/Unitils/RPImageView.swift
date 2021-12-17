//
//  RPImageView.swift
//  ExperimentProduct
//
//  Created by hunin on 2021/12/17.
//

import UIKit
import AsyncDisplayKit

class RPImageView: UIImageView {
    
}

extension ASNetworkImageNode {
    static func imageNode() -> ASNetworkImageNode {
        let manager = RPCache.shared
        return ASNetworkImageNode(cache: manager, downloader: manager)
    }
}

//em... 配置好像出了点问题
extension RPCache: ASImageCacheProtocol, ASImageDownloaderProtocol {
    
    func downloadImage(with URL: URL,
                       shouldRetry: Bool,
                       callbackQueue: DispatchQueue,
                       downloadProgress: ASImageDownloaderProgress?,
                       completion: @escaping ASImageDownloaderCompletion) -> Any? {
        let task: Void = URLSession.shared.dataTask(with: URL, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async {
                    completion(nil,error,nil,nil)
                }
            }
            if URL.absoluteString.contains("webp") {
                if let data = data, let image = UIImage.imageWithWebPData(imageData: data) {
                    DispatchQueue.main.async {
                        completion(image,error,nil,nil)
                    }
                }
            }else{
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image,error,nil,nil)
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
        guard let image = self.cache?.object(forKey: URL.absoluteString) else {
            completion(nil, ASImageCacheType.synchronous)
            return
        }
        completion(image as? ASImageContainerProtocol,ASImageCacheType.synchronous)
    }
    
//    func synchronouslyFetchedCachedImage(with URL: URL) -> ASImageContainerProtocol? {
//
//    }
    
    func clearFetchedImageFromCache(with URL: URL) {
        self.cache?.removeObject(forKey: URL.absoluteString)
    }
}
