//
//  ViewModelProtocol.swift
//  ChatGPTApp
//
//  Created by jun wook on 2023/03/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    var items: BehaviorRelay<[Item]> { get }
    var text: BehaviorRelay<String?> { get }
    var isLoading: PublishSubject<Bool> { get }
    
    func resetUserDefault()
    func setUserDefault(items: [Item])
    func appendItems(item: Item)
    func requestAI(text: String)
}
