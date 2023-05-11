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
    private var screenshotImageViews: [UIImageView] = []
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
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
                self?.configureScreenshots(with: game)
                self?.configureLabel(with: game)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureLabel(with game: Game) {
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
        
        for screenshot in screenshots {
            networkManager.fetchImage(from: screenshot.image) { [weak self] result in
                switch result {
                case .success(let imageData):
                    self?.configureImageView(with: imageData)
                    
                    if self?.screenshotImageViews.count == screenshots.count {
                        self?.addImageViewsToStackView()
                        self?.activityIndicator.stopAnimating()
                        self?.screenshotsStackView.isHidden = false
                        self?.gameDescriptionLabel.isHidden = false
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func addImageViewsToStackView() {
        for imageView in screenshotImageViews {
            screenshotsStackView.addArrangedSubview(imageView)
        }
    }
    
    private func configureImageView(with imageData: (Data)) {
        guard let image = UIImage(data: imageData) else { return }
        
        let imageView = UIImageView(image: image)
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.width - 50).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        screenshotImageViews.append(imageView)
    }
}


