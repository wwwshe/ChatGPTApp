//
//  API+Method.swift
//  ChatGPTApp
//
//  Created by jun wook on 2023/03/25.
//

import Foundation

extension API {
    var method: HTTPMethod {
        switch self {
        case .chatGPT:
            return .post
        }
    }
}
