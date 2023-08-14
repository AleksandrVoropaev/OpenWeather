//
//  Mockable.swift
//
//  Created by Oleksandr Voropayev
//

import Foundation

protocol Mockable {
    static var stub: JSONFileStub { get }
    static var mock: Self? { get }
}

extension Mockable where Self: Decodable {
    static var mock: Self? {
        stub.mock()
    }
}
