//
//  WebViewController.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import WebKit

class ProviderController: UINavigationController {
    
    var request: URLRequest!
    var redirectUri: String!
    var completion: WebRequestService.Completion!
    
    private let cancelButtonTitle = "Cancel"
    
    private var webView: WKWebView!
    private var webViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        configureWebViewController()
        
        pushViewController(webViewController, animated: false)
    }
    
    private func configureWebView() {
        webView = WKWebView(frame: view.bounds)
            webView.navigationDelegate = self
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            webView.load(request)
    }
    
    private func configureWebViewController() {
        webViewController = UIViewController()
        webViewController.view.frame = view.bounds
        webViewController.title = title
        
        webViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: cancelButtonTitle,
                                                                             style: .plain,
                                                                             target: self,
                                                                             action: #selector(cancel))
        
        webViewController.view.addSubview(webView)
    }
    
    func complete(withUrl url: URL?, error: AuthorizeError?) {
        dismiss(animated: true)
        completion(url, error)
    }
    
    @objc func cancel() {
        complete(withUrl: nil, error: AuthorizeError.cancel)
    }
    
}

extension ProviderController: WKNavigationDelegate, WKUIDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.absoluteString.hasPrefix(redirectUri) ?? false {
            complete(withUrl: navigationAction.request.url, error: nil)
           decisionHandler(.cancel)
            
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    // print("didStartProvisionalNavigation - webView.url: (String(describing: webView.url?.description))")
    }
}
