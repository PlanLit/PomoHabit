//
//  NicknameEditView.swift
//  PomoHabit
//
//  Created by 洪立妍 on 3/5/24.
//

import UIKit

import SnapKit

// MARK: - NicknameEditView

final class NicknameEditView: BaseView {
    
    // MARK: - Properties
    
    private let pobitNavigationBarView = PobitNavigationBarView(title: "닉네임 수정", viewType: .withDismissButton)
    private lazy var editSubmitButton = PobitButton.makePlainButton(title: "수정하기", backgroundColor: .pobitRed)
    
    // MARK: - UI
    
    private let nicknameEditTextField: UITextField = {
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
    
    private let nicknameEditLabel: UILabel = {
        let label = UILabel()
        label.text = "대문자만 입력해주세요"
        label.textColor = .pobitStone2
        label.font = Pretendard.regular(size: 14)
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setupTextFieldDelegate()
        nicknameEditTextField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension NicknameEditView {
    private func setAddSubViews() {
        addSubViews([pobitNavigationBarView, nicknameEditTextField, nicknameEditLabel,editSubmitButton])
    }
    
    private func setAutoLayout() {
        pobitNavigationBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        nicknameEditTextField.snp.makeConstraints { make in
            make.top.equalTo(pobitNavigationBarView.snp.bottom).offset(27)
            make.leading.equalTo(safeAreaLayoutGuide).offset(LayoutLiterals.minimumHorizontalSpacing)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(64)
        }
        
        nicknameEditLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameEditTextField.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(LayoutLiterals.minimumHorizontalSpacing)
            
        }
        
        editSubmitButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-34)
            make.centerX.equalToSuperview()
            make.height.equalTo(62)
            make.width.equalTo(324)
        }
    }
}

// MARK: - Methods

extension NicknameEditView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    private func setupTextFieldDelegate() {
        nicknameEditTextField.delegate = self
    }
}
