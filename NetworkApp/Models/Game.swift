//
//  Starwars.swift
//  NetworkApp
//
//  Created by Vsevolod Lashin on 06.05.2023.
//

import Foundation

struct Game: Decodable {
    let id: Int
    let title: String
    let thumbnail: URL
    let short_description: String
    let description: String?
    let game_url: String
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let release_date: String
    let minimum_system_requirements: Requirements?
    let screenshots: [Screenshot]?
}

struct Requirements: Decodable {
    let os: String
    let processor: String
    let memory: String
    let graphics: String
    let storage: String
}

struct Screenshot: Decodable {
    let image: URL
}
