//
//  FlickrListViewModel.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class FlickrListViewModel: ObservableObject {
    
    //MARK: -PROPERTIES
    @Published private (set) var photos: [FlickrViewModel] = []
    @Published var searchText: String = String()
    @Published var isDownloading: Bool = false
    @Published var isDownloaded: Bool = false
    @Published var image: UIImage?
    private var imageCache = ImageCache.getImageCache()
    private var subscription: Set<AnyCancellable> = []
    
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
    
    // download image and manage it on the cache for library
    func downloadAndSaveImage(selectedItem: FlickrViewModel?) {
        self.isDownloading = true
        Task {
            await loadImage(selectedItem: selectedItem)
            saveImageInLibrary()
        }
    }
    
    //If image is set and then save it
    func saveImageInLibrary() {
        guard let image = image else {return}
        let imageSaver = ImageSaver()
        
        imageSaver.writeToPhotoAlbum(image: image)
        
        // We can use "Delegate via "Protocol" how we want."
        NotificationCenter.default.publisher(for: .savingImageInLibrary)
            .map { (notification) -> Bool? in return (notification.object as? Bool) ?? false }
            .receive(on: DispatchQueue.main)
            .sink { value in
                if (value)! {
                    print("Item saved sink  saved !!!!")
                    self.notifyUser()
                } else {
                    print("Item saved sink not saved!!!!")
                    // notify user that can not download and user should try again e.c
                }
            }
            .store(in: &subscription)
    }
    
    //make user friendly with triggers
    func notifyUser() {
        print("notifyUser works after sink !!!!")
        self.isDownloading = false
        self.isDownloaded = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isDownloaded = false
        }
    }
    
    //stop showing downloading view
    func stopDownload() {
        self.isDownloading = false
    }
    
    //if it exists get it from cache, orherwirse from url
    func loadImage(selectedItem: FlickrViewModel?) async {
        print("selectedItem ")
        if loadImageFromCache(selectedItem: selectedItem) {
            return }
        await loadImageFromUrl(selectedItem: selectedItem)
    }
    
    // check saved cache images and get it back
    func loadImageFromCache(selectedItem: FlickrViewModel?) -> Bool {
        print("loadImageFromCache ")
        guard let urlString = selectedItem?.urlToImage else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    // download image from url and then save it in cache
    func loadImageFromUrl(selectedItem: FlickrViewModel?) async {
        print("loadImageFromUrl ")
        guard let urlString = selectedItem?.urlToImage else {
            return
        }
        
        let loadedImage = try? await URLRequest.getImage(urlString: urlString)
        guard let loadedImage = loadedImage else { return }
        self.image = loadedImage
        self.imageCache.set(forKey: urlString, image: loadedImage)
        
    }
}

struct FlickrViewModel {
    //MARK: -PROPERTIES
    let id = UUID()
    
    //DI
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
