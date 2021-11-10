//
//  RPNetWorkManager.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/18.
//

import UIKit
import RxSwift
import Moya
import Alamofire
import SwiftyJSON

class RPNetWorkManager: NSObject {
    
    static let shared = RPNetWorkManager()
    
    let provider = MoyaProvider<NewsMoya>()
    
    func getNews(_ offset: String) -> Observable<[SettingSection]> {
        return Observable<[SettingSection]>.create ({ observable in
            self.provider.request(.news(offset), callbackQueue: DispatchQueue.main) { response in
                switch response {
                case let .success(results):
                    let news = self.parse(results.data)
                    observable.onNext(news)
                    observable.onCompleted()
                case let .failure(error):
                    observable.onError(error)
                }
            }
            return Disposables.create()
        })
    }
    
    func parse(_ data: Any) -> [SettingSection] {
        guard let json = JSON(data)["T1348649079062"].array else { return [] }
        var news: [RPUserInfoModel] = []
        json.forEach {
            guard !$0.isEmpty else { return }
            var imgnewextras: [Imgnewextra] = []
            if let imgnewextraJsonArray = $0["imgnewextra"].array {
                imgnewextraJsonArray.forEach {
                    let subItem = Imgnewextra(imgsrc: $0["imgsrc"].string ?? "")
                    imgnewextras.append(subItem)
                }
            }
            let new = RPUserInfoModel(title: $0["title"].string ?? "", imgsrc: $0["imgsrc"].string ?? "", replyCount: $0["replyCount"].string ?? "", source: $0["source"].string ?? "", imgnewextra: imgnewextras)
            
            news.append(new)
        }
        return [SettingSection(header: "1", items: news)]
    }

}


enum NewsMoya {
    case news(_ offset: String)
    case login(moblie:String,password:String)
    case register(moblie:String,code:String)
    case forgetPassword(moblie:String,code:String,newpassword:String)
    case adLaunch
    case provinces
}


extension NewsMoya: TargetType {
    var baseURL: URL {
        switch self {
        case .news(_):return URL(string: "https://c.m.163.com")!
        case .login(moblie: _, password: _),
             .register(moblie: _, code:  _),
             .forgetPassword(moblie: _, code: _, newpassword: _):
            return URL(string: "https://c.m.163.com")!
        case .adLaunch:
            return URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg1.doubanio.com%2Fview%2Frichtext%2Flarge%2Fpublic%2Fp122617578.jpg&refer=http%3A%2F%2Fimg1.doubanio.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637733990&t=44048b827eb4c729ce27ecd49539d78c")!
        case .provinces:
            return URL(string: "https://code.aliyun.com/hi31588535/outside_chain/raw/master/ssq.json")!
        }
    }
    
    var path: String {
        switch self {
        case .news:
            return "/dlist/article/dynamic"
        case .login:
            return ""
        case .register:
            return ""
        case .forgetPassword:
            return ""
        case .adLaunch:
            return""
        case .provinces:
            return""
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .news(_),.adLaunch,.provinces:return .get
        case .login(moblie: _, password: _),
             .register(moblie: _, code:  _),
             .forgetPassword(moblie: _, code: _, newpassword: _):
            return.post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .news(offset):
            let parameters = ["from": "T1348649079062", "devId": "H71eTNJGhoHeNbKnjt0%2FX2k6hFppOjLRQVQYN2Jjzkk3BZuTjJ4PDLtGGUMSK%2B55", "version": "54.6", "spever": "false", "net": "wifi", "ts": "\(Date().timeStamp)", "sign": "BWGagUrUhlZUMPTqLxc2PSPJUoVaDp7JSdYzqUAy9WZ48ErR02zJ6%2FKXOnxX046I", "encryption": "1", "canal": "appstore", "offset": offset, "size": "10", "fn": "3"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .login(moblie: let moblie, password: let password):
            let paramters = ["moblie":moblie,"password":password]
            return.requestParameters(parameters: paramters, encoding:URLEncoding.default )
            
        case .register(moblie: let moblie, code: let code):
            let paramters = ["moblie":moblie,"code":code]
            return.requestParameters(parameters: paramters, encoding:URLEncoding.default )
            
        case .forgetPassword(moblie: let moblie, code: let code, newpassword: let newpassword):
            let paramters = ["moblie":moblie,"code":code,"newpassword":newpassword]
            return.requestParameters(parameters: paramters, encoding:URLEncoding.default )
        case.adLaunch,.provinces:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "text/plain"]
    }
    
    
}

extension Date {
    var timeStamp: Int {
        return Int(self.timeIntervalSince1970)
    }
}
