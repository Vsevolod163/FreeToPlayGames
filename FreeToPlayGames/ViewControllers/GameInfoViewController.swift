//
//  GameInfoViewController.swift
//  FreeToPlayGames
//
//  Created by Vsevolod Lashin on 06.05.2023.
//

import UIKit

final class GameInfoViewController: UIViewController {

    @IBOutlet var gameDescriptionLabel: UILabel!
    @IBOutlet var screenshotsStackView: UIStackView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var gameId: Int!
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {activityIndicator.startAnimating()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        gameDescriptionLabel.isHidden = true
        screenshotsStackView.isHidden = true
        
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
                self?.configureScreenshots(with: game)
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
    }
    
    private func configureScreenshots(with game: Game) {
        guard let screenshots = game.screenshots else { return }
        
        for subview in screenshotsStackView.subviews {
               subview.removeFromSuperview()
           }
        
        if screenshots.isEmpty {
            networkManager.fetchImage(from: game.thumbnail) { [weak self] result in
                switch result {
                case .success(let imageData):
                    let imageView = UIImageView(image: UIImage(data: imageData))
                    imageView.widthAnchor.constraint(equalToConstant: (self?.view.bounds.width ?? 150) - 32).isActive = true
                    
                    self?.screenshotsStackView.addArrangedSubview(imageView)
                    self?.gameDescriptionLabel.isHidden = false
                    self?.screenshotsStackView.isHidden = false
                    self?.activityIndicator.stopAnimating()
                case .failure(let error):
                    print(error)
                }
            }
            return
        }
        
        for screenshot in screenshots {
            networkManager.fetchImage(from: screenshot.image) { [weak self] result in
                switch result {
                case .success(let imageData):
                    let imageView = UIImageView(image: UIImage(data: imageData))
                    imageView.widthAnchor.constraint(equalToConstant: (self?.view.bounds.width ?? 150) - 50).isActive = true
                    self?.screenshotsStackView.addArrangedSubview(imageView)
                    
                    if screenshot == screenshots.last {
                        self?.gameDescriptionLabel.isHidden = false
                        self?.screenshotsStackView.isHidden = false
                        self?.activityIndicator.stopAnimating()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let imageView = UIImageView(image: UIImage(named: "No Image"))
                        imageView.widthAnchor.constraint(equalToConstant: (self?.view.bounds.width ?? 150) - 32).isActive = true
                        imageView.contentMode = .scaleAspectFill
                        
                        self?.screenshotsStackView.addArrangedSubview(imageView)
                        self?.screenshotsStackView.isHidden = false
                        self?.gameDescriptionLabel.isHidden = false
                        self?.activityIndicator.stopAnimating()
                    }
                    print(error)
                }
            }
        }
    }
}


