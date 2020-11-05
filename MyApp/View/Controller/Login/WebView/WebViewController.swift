//
//  LoginViewController.swift
//  MyApp
//
//  Created by PCI0001 on 2/14/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

final class WebViewController: ViewController {

    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var containerIndicatorView: UIView!

    // MARK: - Properties
    private var webView = WKWebView()
    private var viewModel = WebViewModel()
    private var activityIndicatorView = NVActivityIndicatorView(frame: Config.frameActivitiIndicatorView, type: .ballRotateChase, color: .white, padding: Config.paddingIndicatorView)

    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        configUI()
        loadDataWebView()
    }

    // MARK: - ConfigUI
    private func configUI() {
        title = App.Login.title
        configWebView()
        configLoadingIndicatorView()
    }

    private func configWebView() {
        webView.frame = view.bounds
        view.addSubview(webView)
        webView.navigationDelegate = self
    }

    private func configLoadingIndicatorView() {
        activityIndicatorView.tintColor = .white
        containerIndicatorView.addSubview(activityIndicatorView)
    }

    private func loadDataWebView() {
        let url = viewModel.urlForLoadWebView(type: .authenticate)
        do {
            let request = try URLRequest(url: url.asURL())
            webView.load(request)
        } catch {
            alert(error: error)
        }
    }
}

// MARK: Extension WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if let code = url.getQueryStringParameter(key: "code"), url.absoluteString.hasPrefix("https://www.google.com") {
                let url = viewModel.urlForLoadWebView(type: .accessToken(code: code))
                do {
                    let request = try URLRequest(url: url.asURL())
                    webView.isHidden = true
                    HUD.show()
                    webView.load(request)
                } catch {
                    alert(error: error)
                }
            }
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { [weak self] (html, _) in
            guard let this = self, let token = this.viewModel.convertToken(html: html) else { return }
            HUD.dismiss()
            Session.shared.accessToken = token
            AppDelegate.shared.setRootViewController(root: .home)
        })
    }
}

// MARK: - Extension WebViewController
extension WebViewController {

    struct Config {
        static let frameActivitiIndicatorView = CGRect(x: 0, y: 0, width: 60, height: 60)
        static let paddingIndicatorView: CGFloat = 50
    }
}
