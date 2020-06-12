//
//  GalleryCollectionViewCell.swift
//  gallery
//
//  Created by TTN on 10/06/20.
//  Copyright © 2020 TTN. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setImage(data : UIImage)
    {
        self.image.image = data
    }
}
