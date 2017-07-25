//
//  WebviewDisplay.swift
//  SwiftUITestDemo
//
//  Created by Abc on 25/07/17.
//  Copyright © 2017 Websmith Solution. All rights reserved.
//

import Foundation

class WebviewDisplay: UIViewController,UIWebViewDelegate
{
    //private let webView = UIWebView()
    @IBOutlet weak var webView : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  installWebView()
        
       // guard let url = URL(string: "https://en.wikipedia.org/wiki/Volleyball") else { return }
        
//        let request = URLRequest(url: url)
//        webView.load(request)
        
        webView.delegate = self
        let url = URL(string: "https://en.wikipedia.org/wiki/Volleyball")
        let requestObj = URLRequest(url: url!)
        
        webView.loadRequest(requestObj)
        webView.scalesPageToFit = true
    }

}
