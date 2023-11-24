//
//  HomeViewModel.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 17/07/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticsModel] = []
    
    @Published var allDataCoins:[CoinModel] = []
    @Published var portfolioCoins:[CoinModel] = []
    @Published var searchText:String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellable = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankRversed, holdings, holdingReserved, price, priceReserved
    }
    
    init(){
       addSubscriber()
    }
    
    func addSubscriber(){
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink {[weak self] returnedCoins in
                self?.allDataCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        
        //updates portfolio coin
        portfolioDataService.$savedEntity
            .combineLatest($allDataCoins)
            .map { portfolioCoins, coinModels  -> [CoinModel] in
                portfolioCoins.compactMap { portfolioEntity -> CoinModel? in
                    guard let coin = coinModels.first(where: {$0.id == portfolioEntity.coinId}) 
                    else {return nil}
                    return coin.updateHoldings(amount: portfolioEntity.amount)
                }
            }
            .sink {[weak self] (returnedCoins) in
                guard let self = self else {return}
                self.portfolioCoins = sortPortfolioCoin(coins: returnedCoins)
            }
            .store(in: &cancellable)
        
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink {[weak self] returnedData in
                self?.statistics = returnedData
                self?.isLoading = false
            }
            .store(in: &cancellable)
    }
    
    func updatePortfolio(coin:CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filterAndSortCoins(text:String, coins:[CoinModel],sortOption: SortOption) -> [CoinModel]{
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sortOption: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    // we haven't used inout param here because array of coin is coming from async
    private func sortPortfolioCoin(coins:[CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingValues > $1.currentHoldingValues})
        case .holdingReserved:
            return coins.sorted(by: {$0.currentHoldingValues < $1.currentHoldingValues})
        default:
           return coins
        }
    }
    
    
    private func filterCoins(text:String, coins:[CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {return coins}
        
        return coins.filter { coin in
            return coin.name.lowercased().contains(text.lowercased()) || coin.symbol.lowercased().contains(text.lowercased()) || coin.id.lowercased().contains(text.lowercased())
        }
    }
    
    private func sortCoins(sortOption: SortOption, coins:inout [CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .rank, .holdings:
            coins.sort(by: {$0.rank < $1.rank})
        case .rankRversed, .holdingReserved:
            coins.sort(by: {$0.rank > $1.rank})
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReserved:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
        return coins
    }
    
    private func mapGlobalMarketData(marketDataModel:MarketDataModel?, portfolioCoins:[CoinModel]) -> [StatisticsModel]{
        var stats:[StatisticsModel] = []
        
        guard let data = marketDataModel else{
            return stats
        }
        
        let stat1 = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24hUsd)
        let stat2 = StatisticsModel(title: "24h Volume", value: data.volume)
        let stat3 = StatisticsModel(title: "BTC Dominanc", value: data.btcDominance)
        
        let portfolioVal = portfolioCoins.map { coin in
            coin.currentHoldingValues
        }.reduce(0, +)
        
        let previousValue = portfolioCoins.map { coins -> Double in
            let currentVal = coins.currentHoldingValues
            let percentageChange = (coins.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentVal / (1 + percentageChange)
            return previousValue
        }
        .reduce(0, +)
        
        let percentageChange = ((portfolioVal - previousValue) / previousValue) * 100
        
        
        let stat4 = StatisticsModel(title: "Portfolio Value", value: portfolioVal.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [stat1,stat2,stat3,stat4])
        return stats
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
}
