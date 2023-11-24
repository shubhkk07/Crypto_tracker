//
//  Date.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 17/11/23.
//

import Foundation

extension Date {
    
    init(apiDateString: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.date(from: apiDateString)
        self.init()
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortString() -> String {
        return shortFormatter.string(from: self )
    }
    
}
