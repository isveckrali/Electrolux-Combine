//
//  FlickrDetailView.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import SwiftUI

struct FlickrDetailView: View {
    //MARK: -PROPERTIES
    let title: String
    
    //MARK: -FUNCS
    var body: some View {
        Text(title)
    }
}

//MARK: -PREVIEW
struct FlickrDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlickrDetailView(title: "")
    }
}
