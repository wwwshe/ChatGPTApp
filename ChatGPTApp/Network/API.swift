//
//  API.swift
//  ChatGPTApp
//
//  Created by jun wook on 2023/03/25.
//

import Foundation

@frozen enum API {
    case chatGPT(token: String, msg: String)
}

extension API {
    var url: URL {
        return URL(string: baseURL + path)!
    }
}
