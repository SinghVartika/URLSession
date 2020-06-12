//
//  UIImageViewExtension.swift
//  gallery
//
//  Created by TTN on 12/06/20.
//  Copyright © 2020 TTN. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromURL(ImageURL: String) {
        URLSession.shared.dataTask(with: URL(string: ImageURL)!) { (data, response, error) -> Void in
            let queue = OperationQueue()
            let operation = BlockOperation {
                DispatchQueue.main.async {
                    if let data = data {
                        self.image = UIImage(data: data)
                    }
                }
            }
            operation.qualityOfService = .background
            queue.addOperation(operation)
        }.resume()
    }

}
