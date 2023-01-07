//
//  ChatAICell.swift
//  OpenAIApp
//
//  Created by jun wook on 2023/01/07.
//

import UIKit
import RxSwift

class ChatAICell: UITableViewCell {
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.cornerRadius = 4
            backView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
}
