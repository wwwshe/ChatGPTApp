//
//  ChatGPTProtocol.swift
//  ChatGPTApp
//
//  Created by jun wook on 2023/03/25.
//

import Foundation

protocol ChatGPTProtocol {
    
}

extension ChatGPTProtocol {
    var apiKey: String {
        ProcessInfo.processInfo.environment["OPENAI_API_KEY"]!
    }
}
