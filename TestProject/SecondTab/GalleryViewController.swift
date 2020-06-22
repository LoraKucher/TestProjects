//
//  GalleryViewController.swift
//  TestProject
//
//  Created by Lora Kucher on 29.10.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit

final class GalleryViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var model = GalleryModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImages()
        registerCell()
    }
    
    // MARK: - Actions
    @IBAction private func nextButtonTouchUpInside(_ sender: UIButton) {
        scrollCell(with: .next(collectionView: collectionView))
    }
    
    @IBAction private func previousButtonTouchUpInside(_ sender: UIButton) {
        scrollCell(with: .previous(collectionView: collectionView))
    }
    
    // MARK: - Private methods
    private func getImages() {
        model.loadImages()
    }
    
    private func scrollCell(with direction: Direction) {
        direction.action()
    }
    
    private func registerCell() {
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
}

// MARK: - CollectionView datasource
extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell else {
            preconditionFailure("cell is nil")
        }
        
        cell.configCell(with: model.images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - collection view direction
enum Direction {
    case next(collectionView: UICollectionView)
    case previous(collectionView: UICollectionView)
    
    func action() {
        switch self {
            
        case .next(collectionView: let collectionView):
            guard let indexPath = collectionView.indexPathsForVisibleItems.first else {
                return
            }
            collectionView.scrollToItem(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .centeredHorizontally, animated: true)
            
        case .previous(collectionView: let collectionView):
            guard let indexPath = collectionView.indexPathsForVisibleItems.first else {
                return
            }
            collectionView.scrollToItem(at: IndexPath(row: indexPath.row - 1, section: indexPath.section), at: .centeredHorizontally, animated: true)
        }
    }
}
