//
//  HapticManager.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 26/10/23.
//

import Foundation
import SwiftUI

class HapticManager{
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
