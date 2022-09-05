//
//  AlbumSearchView.swift
//  SwiftUI_iTunes
//
//  Created by yeonBlue on 2022/08/30.
//

import SwiftUI

struct AlbumSearchView: View {
    @StateObject var viewModel = AlbumListViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.searchTerm.isEmpty {
                AlbumPlaceholderView(searchTerm: $viewModel.searchTerm)
            } else {
                AlbumListView(viewModel: viewModel)
            }
        }
        .searchable(text: $viewModel.searchTerm) // navigationView가 필요
        .navigationTitle("Search Album")
    }
}

struct AlbumPlaceholderView: View {
    
    @Binding var searchTerm: String
    
    let suggestion = ["BTS", "BlackPink", "ive"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Trending")
                .font(.title)
            ForEach(suggestion, id: \.self) { text in
                Button {
                    searchTerm = text
                } label: {
                    Text(text)
                        .font(.body
                        )
                }

            }
        }
    }
}

struct AlbumSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSearchView()
    }
}
