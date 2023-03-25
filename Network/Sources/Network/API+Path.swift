//
//  API+Path.swift
//  ChatGPTApp
//
//  Created by jun wook on 2023/03/25.
//

import Foundation

public extension API {
    var path: String {
        switch self {
        case .chatGPT:
            return  "/v1/completions"
        }
    }
}
