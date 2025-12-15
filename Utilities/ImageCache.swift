//
//  ImageCache.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
