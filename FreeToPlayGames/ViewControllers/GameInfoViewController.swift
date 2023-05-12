//
//  GameInfoViewController.swift
//  FreeToPlayGames
//
//  Created by Vsevolod Lashin on 06.05.2023.
//

import UIKit

final class GameInfoViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var gameDescriptionLabel: UILabel!
    @IBOutlet var singleImageView: UIImageView!
    @IBOutlet var screenshotsStackView: UIStackView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Unwrapped Optional Properties
    var gameId: Int!
    var imageData: (Data)!
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var screenshotImageViews: [UIImageView] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        updateStartUI()
        fetchGame()
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}

// MARK: - Networking
extension GameInfoViewController {
    private func fetchGame() {
        let gameURL = URL(string: "https://www.freetogame.com/api/game?id=\(gameId ?? 0)")!
        
        networkManager.fetch(Game.self, from: gameURL) { [weak self] result in
            switch result {
            case .success(let game):
                self?.configureScreenshotsStackView(with: game)
                self?.configureLabel(with: game)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureScreenshotsStackView(with game: Game) {
        guard let screenshots = game.screenshots else { return }
        
        for subview in screenshotsStackView.subviews {
            subview.removeFromSuperview()
        }
        
        if screenshots.isEmpty {
            updateSingleImageViewUI()
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
                    DispatchQueue.main.async {
                        self?.updateSingleImageViewUI()
                    }
                    print(error)
                }
            }
        }
    }
}

// MARK: - Update UI Private functions
extension GameInfoViewController {
    private func addImageViewsToStackView() {
        for imageView in screenshotImageViews {
            screenshotsStackView.addArrangedSubview(imageView)
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
    
    private func configureImageView(with imageData: (Data)) {
        guard let image = UIImage(data: imageData) else { return }
        
        let imageView = UIImageView(image: image)
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.width - 50).isActive = true
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        screenshotImageViews.append(imageView)
    }
    
    private func updateStartUI() {
        singleImageView.image = UIImage(data: imageData)
        
        singleImageView.layer.cornerRadius = 10
        singleImageView.clipsToBounds = true
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        gameDescriptionLabel.isHidden = true
        screenshotsStackView.isHidden = true
        singleImageView.isHidden = true
    }
    
    private func updateSingleImageViewUI() {
        activityIndicator.stopAnimating()
        gameDescriptionLabel.isHidden = false
        singleImageView.isHidden = false
    }
}


