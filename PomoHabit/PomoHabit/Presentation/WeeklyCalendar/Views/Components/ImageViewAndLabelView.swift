//
//  ImageViewAndLabelView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

// MARK: - ImageViewAndLabelStackView

class ImageViewAndLabelStackView: UIView {
    
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

extension ImageViewAndLabelStackView {
    private func setAddSubViews() {
        self.addSubViews([imageView,label])
    }
    
    private func setAutoLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        imageView.setContentHuggingPriority(.init(251), for: .horizontal)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        label.setContentHuggingPriority(.init(250), for: .horizontal)
    }
}

// MARK: - Methods

extension ImageViewAndLabelStackView {
    func setUplabel(text : String, font : UIFont?) {
        label.font = font
        label.text = text
        label.textColor = UIColor.pobitStone5
    }
    
    func setUIImageViewImage(image : UIImage?) {
        imageView.image = image
        
    }
}
