//
//  StatisticsModel.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 01/10/23.
//

import Foundation
struct StatisticsModel: Identifiable {
    let id = UUID().uuidString
    let title:String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
