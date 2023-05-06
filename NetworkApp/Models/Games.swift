//
//  Starwars.swift
//  NetworkApp
//
//  Created by Vsevolod Lashin on 06.05.2023.
//

struct Games: Decodable {
    let games: [Game]
}

struct Game: Decodable {
    let title: String
    let thumbnail: String
    let short_description: String
    let game_url: String
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let release_date: String
}
