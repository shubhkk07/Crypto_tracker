//
//  UIApplication.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 01/10/23.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
