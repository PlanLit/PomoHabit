//
//  ImageViewAndLabelView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

// MARK: - ImageViewAndLabelView

final class ImageViewAndLabelView: UIView {
    
    // MARK: - Properties
    
    private lazy var imageView = UIImageView()
    
    private lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension ImageViewAndLabelView {
    private func setAddSubViews() {
        self.addSubViews([imageView,label])
    }
    
    private func setAutoLayout() {
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        imageView.setContentHuggingPriority(.init(251), for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
        label.setContentHuggingPriority(.init(250), for: .horizontal)
    }
}

// MARK: - Methods

extension ImageViewAndLabelView {
    func setUplabel(text: String, font: UIFont?) {
        label.font = font
        label.text = text
        label.textColor = .pobitStone5
    }
    
    func setUIImageViewImage(image: UIImage?) {
        imageView.image = image
    }
}
