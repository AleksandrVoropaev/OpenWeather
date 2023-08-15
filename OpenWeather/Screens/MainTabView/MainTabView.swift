//
//  MainTabView.swift
//
//  Created by Oleksandr Voropayev
//

import SwiftUI

struct MainTabView: View {
    // MARK: - PROPERTIES

    @ObservedObject var viewModel: ViewModel = ViewModel()
    @State private var selectedTab = Tab.forecast

    // MARK: - BODY

    var body: some View {
        TabView(selection: $selectedTab) {
            ForecastView(viewModel: viewModel.forecastViewModel)
                .tabItem {
                    Image(systemName: Constants.Images.forecats)
                    Text(Constants.Strings.forecats)
                }
                .tag(Tab.forecast)

            SearchView(viewModel: viewModel.searchViewModel)
                .tabItem {
                    Image(systemName: Constants.Images.search)
                    Text(Constants.Strings.search)
                }
                .tag(Tab.search)
        }
        .onReceive(viewModel.selectedTab) {
            selectedTab = $0
        }
    }
}

// MARK: - PREVIEW

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

// MARK: - TABS

extension MainTabView {
    enum Tab: Int {
        case forecast
        case search
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
