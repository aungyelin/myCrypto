//
//  CachedImage.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 31/8/2569 BE.
//

import SwiftUI

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

struct CachedImage: View {
    let url: URL?
    
    @State private var image: Image? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
            } else if isLoading {
                ProgressView()
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        let key = url.absoluteString as NSString
        
        if let cached = ImageCache.shared.object(forKey: key) {
            self.image = Image(uiImage: cached)
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { DispatchQueue.main.async { self.isLoading = false } }
            
            if let data = data, let uiImage = UIImage(data: data) {
                ImageCache.shared.setObject(uiImage, forKey: key)
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
}
