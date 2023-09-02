//
//  AnimalsInfoViewController.swift
//  TestTask
//
//  Created by Vladislav on 2.09.23.
//

import Foundation
import WebKit

class AnimalsInfoViewController: UIViewController {
    
    var viewModel: AnimalsInfoViewModelProtocol?
    private var webView: WKWebView!
    
    init(viewModel: AnimalsInfoViewModel? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
        view.backgroundColor = UIColor(named: Constants.backgroundColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.presentInfo(for: webView)
    }
}
