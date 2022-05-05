//
//  FlickrListCell.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import SwiftUI

struct FlickrListCell: View {
    //MARK: -PROPERTIES
    let photo: FlickrViewModel
    
    //MARK: -FUNCS
    var body: some View {
        HStack(alignment: .top) {
            
            AsyncImage(url: URL(string: photo.urlToImage)) { image in
                image.resizable()
                    .frame(maxWidth: screenWidth / 3, maxHeight: screenWidth / 3)
            } placeholder: {
                ProgressView("Loading...")
                    .frame(maxWidth: 100, maxHeight: 100)
            }
        }//: HSTACK
    }
}

//MARK: -PREVIEW
struct FlickrListCell_Previews: PreviewProvider {
    static var previews: some View {
        FlickrListCell(photo: FlickrViewModel(photo: nil))
    }
}
