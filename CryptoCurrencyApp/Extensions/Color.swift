//
//  Color.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 08/07/23.
//

import Foundation
import SwiftUI

extension Color{
    static let theme = ColorTheme()
}

struct ColorTheme{
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let secondaryTextColor = Color("SecondaryColor")
}
