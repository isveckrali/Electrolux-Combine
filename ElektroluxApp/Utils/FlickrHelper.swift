//
//  FlickrHelper.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import Foundation

class FlickrHelper: NSObject {
    
    //Generate url by coming parameters
       class func URLForSearchString(searchString: String, page: Int) -> String {
           
           let search: String = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
           
           let url = "\(Services.BASE_URL)services/rest?api_key=\(API_KEY)&method=flickr.photos.search&tags=\(search)&format=json&nojsoncallback=true&extras=media&extras=url_sq&extras=url_m&per_page=20&page=\(page)"
           
           return url
           
       }
}
