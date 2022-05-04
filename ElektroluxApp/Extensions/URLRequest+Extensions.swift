//
//  URLRequest+Extensions.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import Foundation
import Combine
import UIKit

enum HttpMethodType: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
}

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

struct Resource<T: Decodable> {
    let url: URL
}

extension URLRequest {
    
    // load contents by generic paramteres
    static func load<T>(resource: Resource<T>, methodType: HttpMethodType = .get) -> AnyPublisher<T, Error> {
        
        var request = URLRequest(url: resource.url)
        let session = URLSession.shared
        request.httpMethod = methodType.rawValue
       // request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        return session.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .catch{ _ in Empty<T, Error>()}
            .eraseToAnyPublisher()
    }
    
    //image with async funcs to cache
    static func getImage(urlString: String ) async throws  -> UIImage {
        guard let url = URL(string: urlString) else {
            fatalError("URL is inconrrect!")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)!
    }
    
    
}
