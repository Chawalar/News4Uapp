//
//  WebViewController.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    var urlFromSegue: URL?
    var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navigationTitle ?? ""
        setUpURLRequest()
    }
    
    func setUpURLRequest() {
        if let url = urlFromSegue {
        let urlRequest:URLRequest = URLRequest(url: url)
            myWebView.load(urlRequest)
        }
    }
    
    
}
