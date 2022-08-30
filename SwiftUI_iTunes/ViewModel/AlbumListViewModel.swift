//
//  AlbumListViewModel.swift
//  SwiftUI_iTunes
//
//  Created by yeonBlue on 2022/08/23.
//

import Foundation
import Combine

enum State: Comparable {
    case ready
    case isLoading
    case loadedAll
    case error(String)
}

class AlbumListViewModel: ObservableObject {
    
    @Published var searchTerm: String = ""
    @Published var albums: [Album] = [Album]()
    @Published var state: State = .ready
    
    var subscription = Set<AnyCancellable>()
    var limit = 20
    var page = 0 
    
    init() {
        $searchTerm
            .dropFirst() // 처음 dataStream 발생 방지
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.albums = [Album]()
                self?.page = 0
                self?.fetchAlbums(for: term)
                self?.state = .ready
            }.store(in: &subscription)
    }
    
    func fetchAlbums(for searchTerm: String) {
        
        print("fetchAlbums called", limit, page)
        
        guard !searchTerm.isEmpty else {
            return
        }
        
        guard state == .ready else { return }
        
        let offset = limit * page
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&entity=album&limit=\(limit)&offset=\(offset)") else {
            return
        }
        
        state = .isLoading
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, err in
            if let err = err {
                DispatchQueue.main.async {
                    self?.state = .error("Error: \(err.localizedDescription)")
                }
                
                print(err.localizedDescription)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(AlbumResult.self, from: data)
                    
                    DispatchQueue.main.async {
                        for album in result.results {
                            self?.albums.append(album)
                        }
                        self?.page += 1
                        self?.state = (result.results.count == self?.limit) ? .ready : .loadedAll
                    }
                } catch let err {
                    print(err)
                    DispatchQueue.main.async {
                        self?.state = .error("Error: \(err.localizedDescription)")
                    }
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
