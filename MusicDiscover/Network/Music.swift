//
//  Music.swift
//  MusicDiscover
//
//  Created by hwanghye on 8/11/24.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let resultCount: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let artistName: String
    let trackName: String
    let artworkUrl100: String
}

