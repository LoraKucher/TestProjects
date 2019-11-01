//
//  GalleryModel.swift
//  TestProject
//
//  Created by Lora Kucher on 31.10.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit

class GalleryModel {
    
    var images: [UIImage] = []
    
    func loadImages() {
        images = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "19"), #imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "8"), #imageLiteral(resourceName: "9"), #imageLiteral(resourceName: "10"), #imageLiteral(resourceName: "11"), #imageLiteral(resourceName: "12"), #imageLiteral(resourceName: "13"), #imageLiteral(resourceName: "14"), #imageLiteral(resourceName: "15"), #imageLiteral(resourceName: "16"), #imageLiteral(resourceName: "17"), #imageLiteral(resourceName: "18")]
    }
    
    // TODO: - get images from local json
    private func getImages() {
        guard let json = open(file: "Images", ext: ".json") else { return }
        _ = try! JSONDecoder().decode(Images.self, from: json)
    }
    
    private func open(file name: String, ext: String) -> Data? {
        if let path = Bundle.main.path(forResource: name, ofType: ext) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}

struct Images: Codable {
    var images: [String]
}



