//
//  API+Header.swift
//  ChatGPTApp
//
//  Created by jun wook on 2023/03/25.
//

import Foundation

extension API {
    var header: [String: String] {
        var header = [String: String]()
        switch self {
        case .chatGPT(let token, _):
            header["Content-Type"] = "application/json"
            header["Authorization"] = "Bearer \(token)"
        }
        return header
    }
}
