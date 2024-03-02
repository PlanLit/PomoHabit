//
//  OnboardingChattingCell.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

import SnapKit

// MARK: - OnboardingChattingCell

class OnboardingChattingCell: UICollectionViewCell {
    
    var model: Model?
    
    // MARK: - Properties
    
    static let identifier = "onboardingChattingCell"
    
    var chattingLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        label.font = Pretendard.medium(size: 14)
        label.backgroundColor = .pobitWhite
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textColor = .pobitBlack
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabel()
//        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout Helpers

extension OnboardingChattingCell {
    private func setupLabel() {
        contentView.addSubview(chattingLabel)
    }
    
//    private func setAutoLayout() {
//        chattingLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(contentView)
//        }
//    }
}

// MARK: - Methods

extension OnboardingChattingCell {
    func bind() {
        guard let model = model else { return }
        guard let chattingLabelWidth = chattingLabel.text?.getEstimatedFrame(with: Pretendard.medium(size: 14) ?? .systemFont(ofSize: 14)).width else { return }
        
        if case .receive = model.chatType {
            chattingLabel.snp.makeConstraints { make in
                make.width.equalTo(chattingLabelWidth + 35)
                make.leading.equalTo(contentView.snp.leading).offset(10)
            }
        
        } else  {
            chattingLabel.snp.makeConstraints { make in
                make.trailing.equalTo(contentView.snp.trailing).offset(-10)
                make.width.equalTo(chattingLabelWidth + 35)
            }
            chattingLabel.backgroundColor = .pobitGreen
            chattingLabel.textColor = .pobitWhite
        }
    }
}
