//
//  DetailViewModel.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 07/11/23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    
    @Published var overviewStatistics: [StatisticsModel] = []
    @Published var additionalStatistics: [StatisticsModel] = []
    
    @Published var coinDetail: CoinDetailModel? = nil
    
    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var websiteUrl: String? = nil
    @Published var redditUrl: String? = nil
    
    
    private var anyCancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapStatisticsData)
            .sink {[weak self] returnedCoinDetail in
                self?.overviewStatistics = returnedCoinDetail.overview
                self?.additionalStatistics = returnedCoinDetail.additional
//                self?.coinDetail = returnedCoinDetail
            }
            .store(in: &anyCancellables)
        
        
        coinDetailService.$coinDetail
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails?.description?.en
            }
    }
    
    
    private func mapStatisticsData(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticsModel], additional: [StatisticsModel]){
        
        var overviewStats: [StatisticsModel] = []
        
        let price = coinModel.currentPrice.asCurrencyWith2Decimals()
        let pricePercentage = coinModel.priceChangePercentage24H
        let priceStats = StatisticsModel(title: "Current Price", value: price, percentageChange: pricePercentage)
        
        let marketCapital = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCaptialPercentchange = coinModel.marketCapChangePercentage24H
        let marketStats = StatisticsModel(title: "Market Captialization", value: marketCapital, percentageChange: marketCaptialPercentchange)
        
        let rank = coinModel.rank
        let rankStats = StatisticsModel(title: "Rank", value: "\(rank)")
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStats = StatisticsModel(title: "Volume", value: volume)
        
        overviewStats.append(contentsOf: [priceStats, marketStats, rankStats, volumeStats])
        
        var additionalStats: [StatisticsModel] = []
        
        let currentHighPrice = coinModel.high24H?.asCurrencyWith2Decimals() ?? "n/a"
        let currentHightPriceStats = StatisticsModel(title: "24h High", value: currentHighPrice)
        
        let currentLowPrice = coinModel.low24H?.asCurrencyWith2Decimals() ?? "n/a"
        let currentLowPriceStats = StatisticsModel(title: "24h Low", value: currentLowPrice)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith2Decimals() ?? "n/a"
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceChangeStats = StatisticsModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentageChange)
        
        let marketCapChange = (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage24H = coinModel.marketCapChangePercentage24H
        let marketStats2 = StatisticsModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapChangePercentage24H)
        
        let blockTimeInMinutes = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeInMinutesString = coinDetailModel?.blockTimeInMinutes != 0 ? "\(coinDetailModel?.blockTimeInMinutes)" : "n/a"
        let blockStats = StatisticsModel(title: "Block Time", value: blockTimeInMinutesString)
        
        let hashingAlgorithm = "\(coinDetailModel?.hashingAlgorithm ?? "n/a")"
        let hashingStats = StatisticsModel(title: "Hashing Algorithm", value: hashingAlgorithm)
        
        additionalStats.append(contentsOf: [currentHightPriceStats, currentLowPriceStats, priceChangeStats,marketStats2, blockStats, hashingStats])
        
        return (overviewStats, additionalStats)
    }
    
    
}
