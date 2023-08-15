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
    @State private var isAlertPresented = false

    // MARK: - BODY

    var body: some View {
        GeometryReader { reader in
            ScrollView {
                Group {
                    if let temperature = viewModel.weather?.main.temp {
                        VStack {
                            Text(String(format: Constants.Strings.temperatureFormat, temperature))
                            Text(viewModel.userLocation.map(\.name) ?? Constants.Strings.yourLocation)
                                .font(.system(size: 18, weight: .light))
                        }
                    } else {
                        Text(Constants.Strings.emptyTemperature)
                    }
                }
                .foregroundColor(.accentColor)
                .font(.system(size: 100, weight: .thin))
                .frame(maxWidth: .infinity, minHeight: reader.size.height)
                .overlay(alignment: .top) {
                    Text(Constants.Strings.pullToRefresh)
                        .secondary()
                }
            }
            .refreshable {
                viewModel.refreshForecast()
            }
        }
        .alert(isPresented: $isAlertPresented, error: viewModel.error) {}
        .onReceive(viewModel.$error) {
            guard $0 != nil else { return }

            isAlertPresented = true
        }
    }
}

// MARK: - PREVIEW

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}

// MARK: - CONSTANTS

private enum Constants {
    // Change with the localization framework of your choice
    enum Strings {
        static let pullToRefresh = "pull to refresh"
        static let temperatureFormat = "%.0f℃"
        static let emptyTemperature = "--"
        static let yourLocation = "Your Location"
    }
}
