//
//  ViewModel.swift
//  OpenAIApp
//
//  Created by jun wook on 2023/01/07.
//

import Foundation
import RxSwift
import RxCocoa
import Network

final class ViewModel: ViewModelProtocol, ChatGPTProtocol {
    private var getItems: [Item] {
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
    
    var isLoading = PublishSubject<Bool>()
    
    let userDefault = UserDefaults.standard
    let disposeBag = DisposeBag()
    
    let session: URLSession!
    
    init(session: URLSession) {
        self.session = session
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
    
    /// 요청 결과 받아오기
    /// - Parameter text: 요청 문구
    func requestAI(text: String) {
        isLoading.onNext(true)
        let api = API.chatGPT(token: apiKey, msg: text)
        let requester = Requester(api: api,
                                  session: session)
        requester.requestChatGPT()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] result in
                self?.isLoading.onNext(false)
                
                switch result {
                case.success(let success):
                    let result = success.choices
                        .first?
                        .text?
                        .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    self?.appendItems(item: Item(type: .ai, text: result))
                case .failure(let failure):
                    self?.appendItems(item: Item(type: .ai, text: failure.localizedDescription))
                }
            } onFailure: { [weak self] error in
                self?.appendItems(item: Item(type: .ai, text: error.localizedDescription))
            }
            .disposed(by: disposeBag)
    }
}
