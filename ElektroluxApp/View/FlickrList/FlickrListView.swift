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
    @State var selectedItem: FlickrViewModel? {
        didSet {
            if selectedItem?.id == oldValue?.id {
                selectedItem = nil
            }
            vm.stopDownload()
        }
    }
    
    
    //MARK: -FUNCS
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        // Downlading Button
                        Button(action: {
                            // download selected item content
                            vm.downloadAndSaveImage(selectedItem: self.selectedItem)
                            vm.isDownloaded = true
                            
                        }, label: {
                            Label("Save", systemImage: "")
                            
                        })
                        .disabled(selectedItem == nil || vm.isDownloading ? true : false)
                        .frame(alignment: .trailing)
                        .padding(.trailing, 32)
                    } //: HStack
                    SearchBar(text: $vm.searchText)
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, spacing: 20) {
                            ForEach(vm.photos, id: \.id) { item in
                                FlickrListCell(photo: item)
                                    .opacity(self.selectedItem?.id == item.id ? 0.5 : 1)
                                    .onTapGesture {
                                        self.selectedItem = item
                                    }
                            }//: LOOP
                        }//: LAZYVGRID
                    } //: SCROLLVIEW
                    if vm.isDownloading{
                        ProgressView("Downloading...")
                            .frame(maxWidth: 100, maxHeight: 100)
                    }
                }//: VSTACK
                .navigationTitle("Flickr")
                .navigationBarTitleDisplayMode(.inline)
                
                
                if vm.isDownloaded {
                    CustomAlertView(alertContent: "Image downloaded", isDownloaded: $vm.isDownloaded)
                }
            }//: ZSTACK
            
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
