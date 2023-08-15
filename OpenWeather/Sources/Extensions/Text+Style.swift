//
//  Text+Style.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 15.08.2023.
//

import SwiftUI

extension Text {
    func secondary() -> some View {
        modifier(SecondaryText())
    }
}

struct SecondaryText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .light))
            .foregroundColor(.secondary)
    }
}
