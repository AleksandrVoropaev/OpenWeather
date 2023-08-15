//
//  SearchItemView.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import SwiftUI

struct SearchItemView: View {
    // MARK: - PROPERTIES

    let item: GeoItem

    // MARK: - BODY

    var body: some View {
        HStack {
            Text(item.displayName)
                .font(.system(size: 18, weight: .light))
                .foregroundColor(.accentColor)
            Spacer()
        }
        .padding()
    }
}

// MARK: - PREVIEW

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        if let mock = GeoItem.mock {
            SearchItemView(item: mock)
        } else {
            EmptyView()
        }
    }
}
