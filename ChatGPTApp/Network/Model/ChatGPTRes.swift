//
//  ChatGPTRes.swift
//  ChatGPTApp
//
//  Created by jun wook on 2023/03/25.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let chatGPTRes = try ChatGPTRes(json)

import Foundation

// MARK: - ChatGPTRes
struct ChatGPTRes: Codable {
    let id, object: String?
    let created: Int?
    let model: String?
    let choices: [Choice]
    let usage: Usage?
}

// MARK: ChatGPTRes convenience initializers and mutators

extension ChatGPTRes {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ChatGPTRes.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String?? = nil,
        object: String?? = nil,
        created: Int?? = nil,
        model: String?? = nil,
        choices: [Choice] = [],
        usage: Usage?? = nil
    ) -> ChatGPTRes {
        return ChatGPTRes(
            id: id ?? self.id,
            object: object ?? self.object,
            created: created ?? self.created,
            model: model ?? self.model,
            choices: choices,
            usage: usage ?? self.usage
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Choice
struct Choice: Codable {
    let text: String?
    let index: Int?
    let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case text, index
        case finishReason = "finish_reason"
    }
}

// MARK: Choice convenience initializers and mutators

extension Choice {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Choice.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        text: String?? = nil,
        index: Int?? = nil,
        finishReason: String?? = nil
    ) -> Choice {
        return Choice(
            text: text ?? self.text,
            index: index ?? self.index,
            finishReason: finishReason ?? self.finishReason
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Usage
struct Usage: Codable {
    let promptTokens, completionTokens, totalTokens: Int?

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: Usage convenience initializers and mutators

extension Usage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Usage.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        promptTokens: Int?? = nil,
        completionTokens: Int?? = nil,
        totalTokens: Int?? = nil
    ) -> Usage {
        return Usage(
            promptTokens: promptTokens ?? self.promptTokens,
            completionTokens: completionTokens ?? self.completionTokens,
            totalTokens: totalTokens ?? self.totalTokens
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
