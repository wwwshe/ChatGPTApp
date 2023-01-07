//
//  ViewModel.swift
//  OpenAIApp
//
//  Created by jun wook on 2023/01/07.
//

import Foundation
import RxSwift
import RxCocoa
import OpenAISwift

final class ViewModel {
    enum ItemType {
        case my
        case ai
    }
    
    struct Item {
        let type: ItemType
        let text: String
    }
    
    let items = BehaviorRelay<[Item]>(value: [Item(type: .my, text: "궁금한 점을 물어보세요!")])
    let text = BehaviorRelay<String?>(value: nil)
    let openAI = OpenAISwift(authToken: "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")
    let isLoading = PublishSubject<Bool>()
    
    func appendItems(item: Item) {
        var items = self.items.value
        items.insert(item, at: 0)
        self.items.accept(items)
    }
    
    func requestAI(text: String) {
        isLoading.onNext(true)
        openAI.sendCompletion(with: text,
                              model: .gpt3(.davinci),
                              maxTokens: 1000) { [weak self] result in
            switch result {
            case.success(let success):
                let result = success.choices
                    .first?
                    .text
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                self?.appendItems(item: Item(type: .ai, text: result))
            case .failure(let failure):
                self?.appendItems(item: Item(type: .ai, text: failure.localizedDescription))
            }
            self?.isLoading.onNext(false)
        }
    }
}
