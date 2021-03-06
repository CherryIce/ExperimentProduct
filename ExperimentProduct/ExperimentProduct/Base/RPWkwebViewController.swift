//
//  RPWkwebViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/25.
//

import UIKit
import WebKit

class RPWkwebViewController: RPBaseViewController {
    
    private lazy var progressView = UIProgressView()
    private lazy var webView:WKWebView = {
        let config = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        config.userContentController = userContent
        
        let webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    var urlString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        webView.configuration.userContentController.add(LeakAvoider(delegate:self), name: "methodName")
//        if ((urlString?.hasPrefix("http")) == nil) {
//            urlString = "http://" + urlString!
//        }
        let url = NSURL(string: urlString!)
        let requst = URLRequest.init(url: url! as URL)
//        requst.httpMethod = "POST"
//        requst.httpBody = "username=aaa&password=123".data(using: .utf8)
        webView.load(requst)
        
        self.progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 2)
        progressView.progressTintColor = UIColor.red
        progressView.trackTintColor = UIColor.clear
        self.view.addSubview(self.progressView)
    }
    
    func goback() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            }else{
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        webView.stopLoading()
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.scrollView.delegate = nil
        webView.navigationDelegate = nil
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "methodName")
    }
}


extension RPWkwebViewController:WKScriptMessageHandler, WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // ??????????????????????????????
        if "methodName" == message.name {
            // ??????message????????????????????????????????????
            if "close" == message.body as! String {
                
            }
        }
    }
    
    // ???????????????????????????
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // ??????????????????????????????
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // ??????????????????????????????
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = webView.title
    }
    
    // ???????????????????????????
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // ??????????????????????????????????????????
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // ??????????????????????????????????????? -> ????????????
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //????????????
        decisionHandler(.allow)
        //???????????????
        //        decisionHandler(.cancel)
    }
    
    // ?????????????????????????????????????????? -> ????????????
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        decisionHandler(.allow, preferences)
    }
    
}

// fix: https://stackoverflow.com/questions/26383031/wkwebview-causes-my-view-controller-to-leak
class LeakAvoider : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController,didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}
