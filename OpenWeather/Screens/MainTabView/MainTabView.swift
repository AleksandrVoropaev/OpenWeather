//
//  MainTabView.swift
//
//  Created by Oleksandr Voropayev
//

import SwiftUI

struct MainTabView: View {
    // MARK: - PROPERTIES

    @ObservedObject var viewModel: ViewModel = ViewModel()

    // MARK: - BODY

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ForecastView(viewModel: viewModel.forecastViewModel)
                .tabItem {
                    Image(systemName: Constants.Images.forecats)
                    Text(Constants.Strings.forecats)
                }
                .tag(1)

            SearchView(viewModel: viewModel.searchViewModel)
                .tabItem {
                    Image(systemName: Constants.Images.search)
                    Text(Constants.Strings.search)
                }
                .tag(2)
        }
    }
}

// MARK: - PREVIEW

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

// MARK: - CONSTANTS

private enum Constants {
    // Change with the localization framework of your choice
    enum Strings {
        static let forecats = "Forecast"
        static let search = "Search"
    }

    enum Images {
        static let forecats = "cloud.sun"
        static let search = "magnifyingglass"
    }
}
