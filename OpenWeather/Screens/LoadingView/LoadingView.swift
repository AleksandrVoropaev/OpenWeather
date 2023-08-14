//
//  LoadingView.swift
//
//  Created by Oleksandr Voropayev
//

import SwiftUI

struct LoadingView: View {
    // MARK: - PROPERTIES

    var text: String? = Constants.Strings.title

    // MARK: - BODY

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            
            VStack {
                ProgressView()
                    .tint(.accentColor)
                    .scaleEffect(1.5)
                    .padding()

                if let text {
                    Text(text)
                }
            }
        }
    }
}

// MARK: - PREVIEW

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

// MARK: - CONSTANTS

private enum Constants {
    // Change with the localization framework of your choice
    enum Strings {
        static let title = "Loading list"
    }
}
