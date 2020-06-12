//
//  APIManager.swift
//  gallery
//
//  Created by TTN on 12/06/20.
//  Copyright © 2020 TTN. All rights reserved.
//

import UIKit
enum APIError : Error{
    case noNetwork
    case undefinedFormat(String)
}
class APIManager: NSObject {
    //create a url session
    let session = URLSession(configuration: .default)
    
    //create a function for datat task which will get the images from API
    func getImages(completionHandler: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        var arrayOfGalleryItem = [GalleryItem]()
        //create a request
        let request = URLRequest(url: URL(string: "https://picsum.photos/list")!)
        //create a datatask
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse else {
                return
            }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let jsonResult = jsonResult as? [[String: Any]] {
                    //print(jsonResult)
                    for item in jsonResult {
                       //print(item)
                        let newItem = GalleryItem(dataFromAPI: item)
                        //print(newItem)
                        arrayOfGalleryItem.append(newItem)
                    }
                    //print(arrayOfGalleryItem)
                    completionHandler(arrayOfGalleryItem, nil)
                }
                else{
                    completionHandler(nil, APIError.undefinedFormat("kuch bhi") )
                }
            }
            catch let error{
                print(error.localizedDescription)
                completionHandler(nil, error)
            }
        }
        dataTask.resume()
    }
}

