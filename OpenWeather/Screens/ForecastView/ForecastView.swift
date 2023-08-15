//
//  ForecastView.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import SwiftUI

struct ForecastView: View {
    // MARK: - PROPERTIES

    @ObservedObject var viewModel: ViewModel = ViewModel()

    // MARK: - BODY

    var body: some View {
        GeometryReader { reader in
            ScrollView {
                Group {
                    if let temperature = viewModel.weather?.main.temp {
                        VStack {
                            Text(String(format: "%.0f℃", temperature))
                            Text(viewModel.userLocation.map(\.name) ?? "Your location")
                                .font(.system(size: 18, weight: .light))
                        }
                    } else {
                        Text("--")
                    }
                }
                .foregroundColor(.accentColor)
                .font(.system(size: 100, weight: .thin))
                .frame(maxWidth: .infinity, minHeight: reader.size.height)
                .overlay(alignment: .top) {
                    Text("pull to refresh")
                        .font(.system(size: 18, weight: .light))
                }
            }
            .refreshable {
                viewModel.refreshForecast()
            }
        }
    }
}

// MARK: - PREVIEW

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
