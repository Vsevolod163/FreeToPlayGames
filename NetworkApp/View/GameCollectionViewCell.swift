//
//  GameCollectionViewCell.swift
//  NetworkApp
//
//  Created by Vsevolod Lashin on 10.05.2023.
//

import UIKit

final class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var gameImageView: UIImageView!
    @IBOutlet var gameLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with game: Game) {
        gameLabel.text = "\(game.title) - \(game.genre)"
        
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
