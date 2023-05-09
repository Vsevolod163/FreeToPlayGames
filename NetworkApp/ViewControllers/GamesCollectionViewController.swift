//
//  GamesCollectionViewController.swift
//  NetworkApp
//
//  Created by Vsevolod Lashin on 10.05.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

final class GamesCollectionViewController: UICollectionViewController {

    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.fetchGames()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate


}
