//
//  CoinDataService.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 17/07/23.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins:[CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en") else {return}
        
        coinSubscription  = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.completionHandler, receiveValue: {[weak self] returnedData in
                self?.allCoins = returnedData
            })
            

    }
}
