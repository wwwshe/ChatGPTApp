//
//  ViewController.swift
//  OpenAIApp
//
//  Created by jun wook on 2023/01/07.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxGesture
import Toast

final class ViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            self.indicator.isHidden = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        }
    }
    
    @IBOutlet weak var infoButton: UIButton! {
        didSet {
            infoButton.layer.cornerRadius = 4
            infoButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var resetButton: UIButton! {
        didSet {
            resetButton.layer.cornerRadius = 4
            resetButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.layer.cornerRadius = 4
            searchButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    var viewModel: ViewModelProtocol!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let session = URLSession(configuration: .default)
        self.viewModel = ViewModel(session: session)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let session = URLSession(configuration: .default)
        self.viewModel = ViewModel(session: session)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        textField.rx
            .text
            .orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: viewModel.text)
            .disposed(by: disposeBag)
        
        searchButton.rx
            .tap
            .throttle(.milliseconds(200),
                      latest: false,
                      scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] _ in
                self?.searchAction()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        infoButton.rx
            .tap
            .throttle(.milliseconds(200),
                      latest: false,
                      scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] _ in
                let alert = UIAlertController(title: "정보", message: "OpenAISwift 라이브러리를 사용하여 ChatGpt에 질문을 하고 답을 받는 앱입니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in 
                    alert.dismiss(animated: true)
                }
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        resetButton
            .rx
            .tap
            .throttle(.milliseconds(200),
                      latest: false,
                      scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] _ in
                let alert = UIAlertController(title: "리셋", message: "이때까지 검색한 히스토리를 삭제합니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                    alert.dismiss(animated: true)
                    self?.viewModel.resetUserDefault()
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                    alert.dismiss(animated: true)
                }
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
          .drive(onNext: { [weak self] keyboardVisibleHeight in
              self?.bottomConstraint.constant = keyboardVisibleHeight
          })
          .disposed(by: disposeBag)
        
        viewModel.items
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items) { [weak self] tableView, _, item in
                guard let self = self else { return UITableViewCell() }
                
                return self.configureItems(tableView: tableView, item: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] isLoading in
                if isLoading {
                    self?.indicator.isHidden = false
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.isHidden = true
                    self?.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func searchAction() {
        guard let text = self.viewModel.text.value?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty == false else {
            self.view.makeToast("검색어를 입력해주세요.", position: .top)
            return
        }
        
        self.viewModel.requestAI(text: text)
        self.viewModel.appendItems(item: Item(type: .my, text: text))
    }
    
    func configureItems(tableView: UITableView, item: Item) -> UITableViewCell {
        switch item.type {
        case .my:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMyCell") as? ChatMyCell else {
                fatalError()
            }
            cell.label.text = item.text
            cell.label.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    UIPasteboard.general.string = cell.label.text
                    self?.view.makeToast("텍스트가 클립보드에 복사 되었습니다.", position: .top)
                })
                .disposed(by: cell.disposeBag)
            return cell
        case .ai:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAICell") as? ChatAICell else {
                fatalError()
            }
            cell.label.text = item.text
            cell.label.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    UIPasteboard.general.string = cell.label.text
                    self?.view.makeToast("텍스트가 클립보드에 복사 되었습니다.", position: .top)
                })
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchAction()
        return true
    }
}
