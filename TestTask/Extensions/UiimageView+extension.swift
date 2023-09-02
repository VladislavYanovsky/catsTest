//
//  UiimageView+extension.swift
//  TestTask
//
//  Created by Vladislav on 2.09.23.
//

import UIKit

extension UIImageView {

    private static let imageCache = NSCache<NSURL, UIImage>()

    func load(url: URL) {
        if let cachedImage = UIImageView.imageCache.object(forKey: url as NSURL) {
            self.image = cachedImage
            print("Loaded image from cache for URL: \(url)")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Data is not an image")
                return
            }

            UIImageView.imageCache.setObject(image, forKey: url as NSURL)

            DispatchQueue.main.async {
                self?.image = image
                print("Downloaded and cached image for URL: \(url)")
                print(image.size)
            }
        }.resume()
    }

    func loadImageFromCache(for url: URL) -> UIImage? {
        return UIImageView.imageCache.object(forKey: url as NSURL)
    }
}
