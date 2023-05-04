//
//  WebViewController.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 04/05/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webView: WKWebView!
    var contestURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    override func viewWillAppear(_ animated: Bool) {
        showRequest()
        activityIndicator.stopAnimating()
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true)
    }
    
    private func showRequest() {
        let request = URLRequest(url: contestURL)
        webView.load(request)
        
    }
}
