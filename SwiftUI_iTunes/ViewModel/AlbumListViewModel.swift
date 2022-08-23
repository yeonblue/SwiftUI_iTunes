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
    var limit = 20
    
    init() {
        $searchTerm
            .dropFirst() // 처음 dataStream 발생 방지)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .flatMap({ term in
                self.fetchAlbumsPublisher(for: term)
            })
            .assign(to: &$albums)
    }
    
    func fetchAlbums(for searchTerm: String) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=BTS&entity=album&limit=5") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(AlbumResult.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.albums = result.results
                    }
                } catch let err {
                    print(err)
                }
            }
        }.resume()
    }
    
    func fetchAlbumsPublisher(for searchTerm: String) -> AnyPublisher<[Album], Never> {
        let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&entity=album&limit=\(limit)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AlbumResult.self, decoder: JSONDecoder())
            .map(\.results)
            .replaceError(with: [Album]())
            .eraseToAnyPublisher()
    }
}
