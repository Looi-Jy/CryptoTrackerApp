//
//  viewModifier.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 12/08/2025.
//
import SwiftUI

struct priceChangeText: ViewModifier {
    let priceChange: Double
    
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(priceChange > 0 ? Color.green : Color.red)
    }
}
