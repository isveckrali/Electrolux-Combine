//
//  FlickrListViewModel.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import Foundation
import Combine
import SwiftUI

@MainActor // 
class FlickrListViewModel: ObservableObject {
    
    //MARK: -PROPERTIES
    @Published private (set) var photos: [FlickrViewModel] = []
    @Published var searchText: String = String()
    private var subscription: Set<AnyCancellable> = []
    private var cancellable: AnyCancellable?

    //MARK: -FUNCS
    init() {
        prepareItemToSearh()
        //searchItems(searchText: "")
    }
    
    //bind item to observe in delayed time
    private func prepareItemToSearh() {
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // debounces the string publisher, such that it delays the process of sending request to remote server.
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    //self.photos = []
                    return ""
                }
                
                return string
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { (_) in
                //
            } receiveValue: { [self] (searchField) in
                print("searchField \(searchField)")
                searchItems(searchText: searchField)
            }.store(in: &subscription)
    }
    
    //search by user tag
    private func searchItems(searchText: String, page:Int = 1) {
        
        let tag = searchText.isEmpty ? "Electrolux" : searchText
        let resource = Resource<FlickrListModel>(url: URL(string: FlickrHelper.URLForSearchString(searchString: tag, page: page))!)
        
        let result = URLRequest.load(resource: resource)
        result.sink { completion in
            switch completion {
            case let .failure(error):
                print("Couldn't get flicrListModel: \(error)")
            case .finished: break
            }
        } receiveValue: { flickrListModel in
            self.photos = (flickrListModel.photos?.photo?.map(FlickrViewModel.init))!
            print("flickrListModel \(flickrListModel)")
        }
        .store(in: &subscription)
    }
}

struct FlickrViewModel {
    //MARK: -PROPERTIES
    let id = UUID()
    let photo: Photo?
    
    var urlToImage: String {
        photo?.urlM ?? ""
    }
    
    var title: String {
        photo?.title ?? ""
    }
    
    var desc: String {
        photo?.owner ?? ""
    }
    
}
