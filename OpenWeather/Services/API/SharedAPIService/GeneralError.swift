//
//  GeneralError.swift
//
//  Created by Oleksandr Voropayev
//

import Foundation

enum GeneralError: Error {
    case decode(Error)
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
