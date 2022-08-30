//
//  AlbumListView.swift
//  SwiftUI_iTunes
//
//  Created by yeonBlue on 2022/08/23.
//

import SwiftUI

struct AlbumListView: View {
    
    @ObservedObject var viewModel: AlbumListViewModel
    
    var body: some View {
            List {
                ForEach(viewModel.albums){ album in
                    Text(album.collectionName)
                }
                
                switch viewModel.state {
                    case .ready:
                        Color.clear
                            .onAppear {
                                viewModel.loadMore()
                            }
                    case .isLoading:
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(width: .infinity)
                    case .loadedAll:
                        EmptyView()
                    case .error(let msg):
                        Text(msg)
                            .foregroundColor(.red)
                }
            }.listStyle(.plain)
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView(viewModel: AlbumListViewModel())
    }
}
