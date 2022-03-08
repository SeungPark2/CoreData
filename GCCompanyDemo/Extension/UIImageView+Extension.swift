//
//  UIImageView+Extension.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/08.
//

import UIKit

import Kingfisher

extension UIImageView {
    
    func downloadImage(with urlString: String) {
        
        guard urlString != "",
              let url = URL(string: urlString) else { return }
        
        KF.url(url)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .resizing(referenceSize: CGSize(width: self.frame.width,
                                          height: self.frame.height))
          .fade(duration: 0.25)
          .onSuccess { result in }
          .onFailure { error in }
          .set(to: self)
    }

}
