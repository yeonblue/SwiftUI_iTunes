//
//  AlbumListViewModel.swift
//  SwiftUI_iTunes
//
//  Created by yeonBlue on 2022/08/23.
//

import UIKit
import Combine

class AlbumListViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var albums: [Album] = [Album]()
    
    var subscription = Set<AnyCancellable>()
    var limit = 5
    var page = 0 {
        didSet {
            self.fetchAlbums(for: searchTerm)
        }
    }
    
    init() {
        $searchTerm
            .dropFirst() // 처음 dataStream 발생 방지)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.albums = [Album]()
                self?.page = 0
                self?.fetchAlbums(for: term)
            }.store(in: &subscription)
    }
    
    func fetchAlbums(for searchTerm: String) {
        
        print("fetchAlbums called", limit, page)
        
        guard !searchTerm.isEmpty else {
            return
        }
        
        let offset = limit * page
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&entity=album&limit=\(limit)&offset=\(offset)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(AlbumResult.self, from: data)
                    
                    DispatchQueue.main.async {
                        for album in result.results {
                            self.albums.append(album)
                        }
                        self.page += 1
                    }
                } catch let err {
                    print(err)
                }
            }
        }.resume()
    }
    
    func loadMore() {
        print("AlbumListViewModel loadMore() called")
        self.fetchAlbums(for: searchTerm)
    }
    
    func fetchAlbumsPublisher(for searchTerm: String) -> AnyPublisher<[Album], Never> {
        let offset = limit * page
        
        let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&entity=album&limit=\(limit)&offset=\(offset)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AlbumResult.self, decoder: JSONDecoder())
            .map(\.results)
            .replaceError(with: [Album]())
            .eraseToAnyPublisher()
    }
}
