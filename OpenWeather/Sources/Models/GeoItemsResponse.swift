//
//  GeoItemsResponse.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation

struct GeoItem: Decodable, Hashable{
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state
    }
}

extension GeoItem {
    var displayName: String {
        name + (state.map { ", " + $0 } ?? "") + ", " + country
    }
}

extension GeoItem: Mockable {
    static var stub: JSONFileStub { .makeResourceGeoItem200() }
}

extension JSONFileStub {
    static func makeResourceGeoItem200() -> Self {
        .getResource(.geoItemResponse, 200)
    }
}
