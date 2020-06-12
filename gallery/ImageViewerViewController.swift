//
//  ImageViewerViewController.swift
//  gallery
//
//  Created by TTN on 12/06/20.
//  Copyright © 2020 TTN. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {

    @IBOutlet weak var galleryImage: UIImageView!
    var galleryModelItem: GalleryItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            if let galleryItem = self.galleryModelItem {
                self.galleryImage.setImageFromURL(ImageURL: galleryItem.thumbnailURL)
            }
        }
    }
    
    @IBAction func didTappedAuthor(_ sender: UIButton) {
        
        if let url = URL(string: galleryModelItem!.author_url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func didTappedReturnButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

