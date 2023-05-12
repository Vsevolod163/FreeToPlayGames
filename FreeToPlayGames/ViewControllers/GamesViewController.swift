//
//  GamesCollectionViewController.swift
//  FreeToPlayGames
//
//  Created by Vsevolod Lashin on 10.05.2023.
//

import UIKit

final class GamesViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    
    private let networkManager = NetworkManager.shared
    private var allGames: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        collectionView.isHidden = true
        
        fetchGames()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let gameInfoVC = navigationVC.topViewController as? GameInfoViewController else { return }
        guard let indexPaths = collectionView.indexPathsForSelectedItems, let indexPath =  indexPaths.first else { return }
        
        gameInfoVC.gameId = allGames[indexPath.item].id
        gameInfoVC.imageData = sender as? Data
    }
}

// MARK: - UICollectionViewDataSource
extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showGame", for: indexPath)
        guard let gameVC = cell as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }
        let game = allGames[indexPath.item]
        
        gameVC.gameLabel.text = "\(game.title) - \(game.genre)"
        
        networkManager.fetchImage(from: game.thumbnail) { [weak self] result in
            switch result {
            case .success(let imageData):
                gameVC.gameImageView.image = UIImage(data: imageData)
                collectionView.isHidden = false
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = allGames[indexPath.item]
        
        networkManager.fetchImage(from: game.thumbnail) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.performSegue(withIdentifier: "showGame", sender: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GamesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: view.frame.height / 3)
    }
}

// MARK: - Networking
extension GamesViewController {
    private func fetchGames() {
        let gamesURL = URL(string: "https://www.freetogame.com/api/games")!
        
        networkManager.fetch([Game].self, from: gamesURL) { [weak self] result in
            switch result {
            case .success(let games):
                self?.allGames = games
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
