//
//  AlbumListView.swift
//  SwiftUI_iTunes
//
//  Created by yeonBlue on 2022/08/23.
//

import SwiftUI

struct AlbumListView: View {
    
    @StateObject var viewModel = AlbumListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.albums){ album in
                    Text(album.collectionName)
                }
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .onAppear {
                        //viewModel.loadMore()
                    }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchTerm) // navigationView가 필요
            .navigationTitle("Search Album")
        }
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView()
    }
}
