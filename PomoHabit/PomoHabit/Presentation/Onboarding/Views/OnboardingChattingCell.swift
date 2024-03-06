//
//  OnboardingChattingCell.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

// MARK: - OnboardingChattingCell

final class OnboardingChattingCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var model: OnboardingModel?
    
    private lazy var chattingLabel: BasePaddingLabel = makeChattingLabel()
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Layout Helpers

extension OnboardingChattingCell {
    private func setAddSubviews() {
        contentView.addSubview(chattingLabel)
    }
    
    private func setAutoLayout() {
        chattingLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    func configureCell(with model: OnboardingModel) {
        self.backgroundColor = .clear
        self.chattingLabel.text = model.message
        self.model = model
        
        switch model.chatType {
        case .receive:
            chattingLabel.snp.makeConstraints { make in
                make.leading.equalTo(contentView.snp.leading).offset(LayoutLiterals.minimumHorizontalSpacing)
            }
        case .send:
            chattingLabel.snp.makeConstraints { make in
                make.trailing.equalTo(contentView.snp.trailing).offset(-LayoutLiterals.minimumHorizontalSpacing)
            }
            chattingLabel.backgroundColor = .pobitGreen
            chattingLabel.textColor = .pobitWhite
        }
    }
}

// MARK: - Factory Methods

extension OnboardingChattingCell {
    private func makeChattingLabel() -> BasePaddingLabel {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        label.font = Pretendard.medium(size: 16)
        label.backgroundColor = .pobitWhite
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textColor = .pobitBlack
        
        return label
    }
}
