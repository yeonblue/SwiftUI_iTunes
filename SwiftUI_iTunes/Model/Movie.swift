//
//  Movie.swift
//  SwiftUI_iTunes
//
//  Created by yeonBlue on 2022/08/23.
//

import Foundation

// https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html
// https://itunes.apple.com/search?term=BTS&entity=movie&limit=5

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieResult = try? newJSONDecoder().decode(MovieResult.self, from: jsonData)

import Foundation

// MARK: - MovieResult
struct MovieResult: Codable {
    let resultCount: Int
    let results: [Movie]
}

// MARK: - Result
struct Movie: Codable {
    let wrapperType, kind: String
    let trackID: Int
    let artistName, trackName, trackCensoredName: String
    let trackViewURL: String
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String
    let collectionPrice, trackPrice, trackRentalPrice, collectionHDPrice: Double?
    let trackHDPrice, trackHDRentalPrice: Double?
    let releaseDate: Date
    let collectionExplicitness, trackExplicitness: String
    let trackTimeMillis: Int?
    let country, currency, primaryGenreName, contentAdvisoryRating: String
    let shortDescription: String?
    let longDescription: String
    let artistID: Int?
    let artistViewURL: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case trackID = "trackId"
        case artistName, trackName, trackCensoredName
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, trackRentalPrice
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case trackHDRentalPrice = "trackHdRentalPrice"
        case releaseDate, collectionExplicitness, trackExplicitness, trackTimeMillis, country, currency, primaryGenreName, contentAdvisoryRating, shortDescription, longDescription
        case artistID = "artistId"
        case artistViewURL = "artistViewUrl"
    }
}
