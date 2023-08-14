//
//  Resource.swift
//
//  Created by Oleksandr Voropayev
//

import Foundation

protocol Resource {
    var name: String { get }
    var fileType: String { get }
}

struct JSONResource: Resource {
    var name: String
    var fileType: String = "json"
}

struct JSONFileStub {
    private let loadData: (Bundle) -> Data
    private let resource: JSONResource
    private let statusCode: Int
    
    init(
        resource: JSONResource,
        statusCode: Int
    ) {
        self.resource = resource
        self.statusCode = statusCode
        self.loadData = { bundle in
            guard
                let path = bundle.path(forResource: resource.name, ofType: resource.fileType),
                let data = try? String(contentsOfFile: path).data(using: .utf8)
            else {
                fatalError("Cant load resource \(resource.name)")
            }
            
            return data
        }
    }
    
    func loadData(bundle: Bundle) -> Data {
        loadData(bundle)
    }
}

extension JSONFileStub {
    static func getResource(_ fileName: JSONFile, _ code: Int) -> Self {
        .init(resource: JSONResource(name: fileName.rawValue), statusCode: code)
    }
}

extension JSONFileStub {
    func mock<T: Decodable>(bundle: Bundle = .main) -> T? {
        let data = self.loadData(bundle: bundle)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try? decoder.decode(T.self, from: data)
    }
}
