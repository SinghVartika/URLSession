//
//  ViewController.swift
//  gallery
//
//  Created by TTN on 10/06/20.
//  Copyright © 2020 TTN. All rights reserved.
//

import UIKit
import Alamofire


struct galleryImage : Codable
{
    var format : String
    var width : Int
    var height : Int
    var filename : String
    var id : Int
    var author : String
    var author_url : String
    var post_url : String
}

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var images : UICollectionView?
    var gallery : [galleryImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDataImages()
        let nib = UINib.init(nibName: "GalleryCollectionViewCell", bundle: nil)
        images?.register(nib, forCellWithReuseIdentifier: "galleryImageCell")
    }
    
    func getDataImages() {
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        AF.request("https://picsum.photos/list", method: .get, parameters: nil, encoding: URLEncoding.default)
            .responseData { [weak self] response in
                switch response.result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .useDefaultKeys
                        let result = try decoder.decode(galleryImage.self, from: data)
                        self?.gallery?.append(result) 
                        print(result)
                    } catch { print(error) }
                }
                
//                self?.images!.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryImageCell", for: indexPath) as! GalleryCollectionViewCell
        if let url = URL(string: "https://i.picsum.photos/id/1/200/300.jpg") {

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {

                        //here i pass image to cell.FlagImage
                        cell.setImage(data: UIImage(data: data)!)
                    }
                }
            }.resume()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: gallery?[indexPath.row].width ?? 300 , height: gallery?[indexPath.row].height ?? 300)
            
    }

}
