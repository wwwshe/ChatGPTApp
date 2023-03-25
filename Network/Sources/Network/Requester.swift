//
//  Requester.swift
//  Network
//
//  Created by jun wook on 2023/03/25.
//

import RxSwift
import RxCocoa
import Foundation

public struct Requester {
    public let api: API
    public let session: URLSession
    
    public init(api: API, session: URLSession) {
        self.api = api
        self.session = session
    }
}

public extension Requester {
    /// ChatGTP 요청
    /// - Parameter text: 요청 문구
    /// - Returns: 결과
    func requestChatGPT() -> Single<Result<ChatGPTRes, URLError>> {
        
        let request = NSMutableURLRequest(url: api.url)
        request.httpMethod = api.method.rawValue
        request.allHTTPHeaderFields = api.header
        request.httpBody = api.body
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let response = String(data: data, encoding: .utf8)
                    debugPrint("[response] \n \(response ?? "no response")")
                    let chatGPTRes = try ChatGPTRes(data: data)

                    return .success(chatGPTRes)
                } catch {
                    return
                        .failure(URLError(.cannotParseResponse))
                }
            }
            .catch { _ in
                    .just(Result.failure(URLError(.cannotLoadFromNetwork)))
            }
            .asSingle()
    }
}
