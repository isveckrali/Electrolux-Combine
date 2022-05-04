//
//  FlickrListModel.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import Foundation

struct FlickrListModel: Decodable {
    var photos: Photos?
    
}

struct Photos: Decodable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: Int?
    var photo: [Photo]?
    var stat: String?
    
}

struct Photo: Decodable, Identifiable, Equatable {
    var picId: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var isPublic: Int?
    var isFriend: Int?
    var isFamily: Int?
    var urlM: String?
    var heightM: Int?
    var widthM: Int?
    
    private enum CodingKeys: String, CodingKey {
        //do readable code with swift syntax
        case picId = "id", owner, secret, server, farm, title, isPublic = "ispublic", isFriend = "isfriend", isFamily = "isfamily", urlM = "url_m", heightM = "height_m", widthM = "width_m"
    }
}

extension Photo {
    var id: String {
        return UUID().uuidString
    }
}
