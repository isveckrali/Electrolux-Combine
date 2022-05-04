//
//  FlickrListView.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 03/05/2022.
//

import SwiftUI

struct FlickrListView: View {
    //MARK: - PROPERTIES
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @ObservedObject var vm = FlickrListViewModel()
    
    //MARK: -FUNC
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    // Downlading Button
                    Button(action: {
                        // download selected
                    }, label: {
                    Label("Save", systemImage: "")
                    })
                    .frame(alignment: .trailing)
                    .padding(.trailing, 32)
                } //: HStack
                SearchBar(text: $vm.searchText)

                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(vm.photos, id: \.id) { item in
                            NavigationLink(destination: FlickrDetailView(title: item.title)) {
                                FlickrListCell(photo: item)
                            }
                        }//: LOOP
                    }//: LAZYVGRID
                } //: SCROLLVIEW
                Spacer()
            }//VSTACK
            .navigationTitle("Flickr")
            .navigationBarTitleDisplayMode(.inline)
            
        }// NavigationView
        .navigationViewStyle(.stack)
    }
}

//MARK: -PREVIEW
struct FlickrListView_Previews: PreviewProvider {
    static var previews: some View {
        FlickrListView()
            .previewInterfaceOrientation(.portrait)
    }
}
