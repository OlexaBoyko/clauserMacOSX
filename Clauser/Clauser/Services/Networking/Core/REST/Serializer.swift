//
//  Serializer.swift
//  Do a Wilson
//
//  Created by Dmytro Antonchenko on 3/21/18.
//  Copyright © 2018 Dmytro Antonchenko. All rights reserved.
//

import Foundation

protocol Serializer {
    static func serialize<T: Codable>(expectedModelType: T.Type, data: Data?) -> T?
    static func serialize<T: Codable>(expectedModelType: T.Type, forKey: String, data: Data?) -> T?
    static func serializeArray<T: Codable>(expectedModelType: T.Type, data: Data?) -> [T]?
    static func serializeArray<T: Codable>(expectedModelType: T.Type, forKey: String, data: Data?) -> [T]?
}
