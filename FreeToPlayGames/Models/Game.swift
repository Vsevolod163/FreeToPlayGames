//
//  Game.swift
//  FreeToPlayGames
//
//  Created by Vsevolod Lashin on 06.05.2023.
//

import Foundation

struct Game: Decodable {
    let id: Int
    let title: String
    let thumbnail: URL
    let description: String?
    let gameUrl: URL
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let releaseDate: String
    let screenshots: [Screenshot]?
}

struct Screenshot: Decodable, Equatable {
    let image: URL
}
