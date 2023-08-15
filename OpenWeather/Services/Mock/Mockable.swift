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

protocol ArrayMockable {
    static var stubWithArray: JSONFileStub { get }
    static var mocksArray: [Self] { get }
}

extension ArrayMockable where Self: Decodable {
    static var mocksArray: [Self] {
        stubWithArray.mock() ?? []
    }
}
