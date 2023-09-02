//
//  AnimalsInfoViewModel.swift
//  TestTask
//
//  Created by Vladislav on 2.09.23.
//

import Foundation
import WebKit

protocol AnimalsInfoViewModelProtocol {
    func presentInfo(for webView: WKWebView)
}

class AnimalsInfoViewModel: AnimalsInfoViewModelProtocol {
    
    var animal: Animal?
    
    init(animal: Animal? = nil) {
        self.animal = animal
    }
    
    func presentInfo(for webView: WKWebView) {
        if let weikiUrlString = animal?.wikipediaURL,
           let url = URL(string: weikiUrlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
