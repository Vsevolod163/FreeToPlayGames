//
//  GamesCollectionViewController.swift
//  NetworkApp
//
//  Created by Vsevolod Lashin on 10.05.2023.
//

import UIKit

final class GamesCollectionViewController: UICollectionViewController {

    private let networkManager = NetworkManager.shared
    private var allGames: [Game] = []
    private let gamesURL = URL(string: "https://www.freetogame.com/api/games")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGames()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let gameInfoVC = navigationVC.topViewController as? GameInfoViewController else { return }
        guard let indexPaths = collectionView.indexPathsForSelectedItems, let indexPath =  indexPaths.first else { return }
        
        gameInfoVC.gameId = allGames[indexPath.item].id
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allGames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showGame", for: indexPath)
        guard let gameVC = cell as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }
        let game = allGames[indexPath.item]
        gameVC.configure(with: game)
    
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GamesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 250)
    }
}

// MARK: - Networking
extension GamesCollectionViewController {
    private func fetchGames() {
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
