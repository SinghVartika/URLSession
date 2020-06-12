//
//  GalleryViewController.swift
//  gallery
//
//  Created by TTN on 12/06/20.
//  Copyright © 2020 TTN. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let readAndWrite = ReadAndWrite<GalleryItem>()
    let obj = APIManager()
    var galleryItemArray : [GalleryItem]?
    var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        return indicatorView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        //register the nib
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "imageCell")
        
        //adding activityindicator to view
        view.addSubview(activityIndicator)
        //
        DispatchQueue.global(qos: .background).async {
            self.obj.getImages { [weak self] (response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    self?.readAndWrite.saveToLocalStorageM(data: response as! [GalleryItem])
                    self?.galleryItemArray = self?.readAndWrite.readFromLocalStorage()
                    //print(self?.galleryItemArray)
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                    }
                }
            }
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let galleryItem = galleryItemArray else { return 0 }
        return galleryItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        activityIndicator.startAnimating()
        if let thumbnailURL: String =  galleryItemArray?[indexPath.row].thumbnailURL {
            DispatchQueue.main.async {
                cell.thumbnail.setImageFromURL(ImageURL: thumbnailURL)
            }
        }
        activityIndicator.stopAnimating()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "ImageViewerViewController") as! ImageViewerViewController
        vc.galleryModelItem = self.galleryItemArray?[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}
