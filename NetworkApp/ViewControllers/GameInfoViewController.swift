//
//  ViewController.swift
//  NetworkApp
//
//  Created by Vsevolod Lashin on 06.05.2023.
//

import UIKit

final class GameInfoViewController: UIViewController {

    @IBOutlet var gameImageView: UIImageView!
    @IBOutlet var gameDescriptionLabel: UILabel!
    
    var gameId: Int!
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        fetchGame()
    }
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}

// MARK: - Networking
extension GameInfoViewController {
    func fetchGame() {
        let gameURL = URL(string: "https://www.freetogame.com/api/game?id=\(gameId ?? 0)")!
       
        networkManager.fetch(Game.self, from: gameURL) { [weak self] result in
            switch result {
            case .success(let game):
                self?.configure(with: game)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configure(with game: Game) {
        DispatchQueue.main.async { [weak self] in
            self?.gameDescriptionLabel.text = """
                Game: \(game.title)
                Genre: \(game.genre)
                Platform: \(game.platform)
                Publisher: \(game.publisher)
                Developer: \(game.developer)
                Release Date: \(game.releaseDate)
                
                
                \(game.description ?? "No description")
                """
        }
        networkManager.fetchImage(from: game.thumbnail) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.gameImageView.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}


