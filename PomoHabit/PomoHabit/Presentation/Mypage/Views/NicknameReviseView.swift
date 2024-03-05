//
//  NicknameReviseView.swift
//  PomoHabit
//
//  Created by 洪立妍 on 3/5/24.
//

import UIKit

import SnapKit

// MARK: - NicknameResiveView

final class NicknameResiveView: BaseView {
    
    // MARK: - Properties
    
    private let pobitNavigationBarView = PobitNavigationBarView(title: "닉네임 수정")
    private lazy var reviseSubmitButton = PobitButton.makePlainButton(title: "수정하기/등록하기", backgroundColor: .pobitRed)
    
    // MARK: - UI
    
    private let nicknameReviseTextField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "닉네임 입력"
        textField.textColor = .pobitStone1
        textField.font = Pretendard.bold(size: 20)
        textField.layer.borderColor = UIColor.pobitStone4.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        
        return textField
    }()
    
    private let nicknameReviseLabel: UILabel = {
        let label = UILabel()
        label.text = "대문자만 입력해주세요"
        label.textColor = .pobitStone2
        label.font = Pretendard.regular(size: 20)
        
        return label
    }()
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension NicknameResiveView {
    private func setAddSubViews() {
        addSubViews([pobitNavigationBarView, nicknameReviseTextField, nicknameReviseLabel,reviseSubmitButton])
    }
    
    private func setAutoLayout() {
        pobitNavigationBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        nicknameReviseTextField.snp.makeConstraints { make in
            make.top.equalTo(pobitNavigationBarView.snp.bottom).offset(35)
            make.leading.equalTo(safeAreaLayoutGuide).offset(LayoutLiterals.minimumHorizontalSpacing)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(64)
        }
        
        nicknameReviseLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameReviseTextField.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(LayoutLiterals.minimumHorizontalSpacing)
            
        }
        reviseSubmitButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameReviseLabel.snp.bottom).offset(139)
            make.centerX.equalToSuperview()
            make.height.equalTo(62)
            make.leading.equalTo(safeAreaLayoutGuide).offset(61)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(61)
        }
    }
}
