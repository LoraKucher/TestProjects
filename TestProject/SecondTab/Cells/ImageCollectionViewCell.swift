//
//  ImageCollectionViewCell.swift
//  TestProject
//
//  Created by Lora Kucher on 29.10.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageVIew: UIImageView!
    
    func configCell(with image: UIImage) {
        imageVIew.image = image
    }
}
