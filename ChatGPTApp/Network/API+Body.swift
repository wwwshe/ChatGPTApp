//
//  API+Body.swift
//  ChatGPTApp
//
//  Created by jun wook on 2023/03/25.
//

import Foundation

extension API {
    var body: Data {
        var body = [String: Any]()
      
        switch self {
        case .chatGPT(_, let msg):
            body["model"] = "text-davinci-003"
            body["prompt"] = msg
            body["max_tokens"] = 2048
        }
        return try! JSONSerialization.data(withJSONObject: body, options: [])
    }
}
