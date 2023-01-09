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
    enum ItemType: Codable {
        case my
        case ai
    }
    
    struct Item: Codable {
        let type: ItemType
        let text: String
    }
    
    var getItems: [Item] {
        if let objects = UserDefaults.standard.value(forKey: "items") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [Item] {
                return objectsDecoded
            } else {
                return self.items.value
            }
        } else {
            return self.items.value
        }
    }
    
    let items = BehaviorRelay<[Item]>(value: [Item(type: .my, text: "궁금한 점을 물어보세요!")])
    let text = BehaviorRelay<String?>(value: nil)
    let openAI = OpenAISwift(authToken: "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")
    let isLoading = PublishSubject<Bool>()
    
    let userDefault = UserDefaults.standard
    let disposeBag = DisposeBag()
    
    init() {
        self.items.accept(getItems)
        bind()
    }
    
    func bind() {
        items
            .skip(1)
            .subscribe(onNext: { [weak self] items in
                guard items.count > 1 else { return }
                self?.setUserDefault(items: items)
            })
            .disposed(by: disposeBag)
    }
    
    func resetUserDefault() {
        let items = [Item(type: .my, text: "궁금한 점을 물어보세요!")]
        setUserDefault(items: items)
        self.items.accept(items)
    }
    
    func setUserDefault(items: [Item]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items){
            UserDefaults.standard.set(encoded, forKey: "items")
        }
    }
    
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
