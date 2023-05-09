//
//  NetworkManager.swift
//  NetworkApp
//
//  Created by Vsevolod Lashin on 10.05.2023.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()
    
    private let gamesURL = URL(string: "https://www.freetogame.com/api/games")!
    
    private init() {}
    
    func fetchGames() {
        URLSession.shared.dataTask(with: gamesURL) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode([Game].self, from: data)
                print(games)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

