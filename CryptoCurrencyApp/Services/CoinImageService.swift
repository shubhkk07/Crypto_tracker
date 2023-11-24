//
//  CoinImageService.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 23/07/23.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService{
    
    @Published var image:UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    
    private let folderName = "coin_images"
    private let imageName:String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            self.image = savedImage
        } else{
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink { completion in
                NetworkManager.completionHandler(completion: completion)
            } receiveValue: {[weak self] returnedImage in
                guard let self = self,
                      let downloadImage = returnedImage else {return}
                self.image = downloadImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: imageName, folderName: folderName)
            }

    }
}
