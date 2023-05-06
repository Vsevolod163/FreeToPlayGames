//
//  ViewController.swift
//  NetworkApp
//
//  Created by Vsevolod Lashin on 06.05.2023.
//

import UIKit

final class MainViewController: UIViewController {

    private let gamesURL = URL(string: "https://www.freetogame.com/api/games")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGames()
    }


}

// MARK: - Networking
extension MainViewController {
    private func fetchGames() {
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
