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
    private lazy var editSubmitButton = makeEditSubmitButton()
    private let mypageView = MyPageView()
    private var nicknameEditViewController: NicknameViewController?
    
    // MARK: - UI
    
    private let nicknameEditTextField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
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
    
    init(frame: CGRect,_ nickName: String,_ nicknameEditViewController: NicknameViewController) {
        super.init(frame: frame)
        
        self.nicknameEditTextField.text = nickName
        self.nicknameEditViewController = nicknameEditViewController
        
        setAddSubViews()
        setAutoLayout()
        setupTextFieldDelegate()
        setFirstResponderForTextField()
        setPlaceholderForTextField()
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
    
    private func makeEditSubmitButton() -> PobitButton {
        let button = PobitButton(type: .system, primaryAction: .init(handler: { _ in
            self.nicknameEditViewController?.dismiss(animated: true)
        }))
        button.setTitle("수정하기", for: .normal)
        button.backgroundColor = .pobitRed
        button.setTitleColor(.pobitWhite, for: .normal)
        button.titleLabel?.font = Pretendard.medium(size: 24)
        button.layer.borderWidth = 0
        
        return button
    }
}

// MARK: - Methods

extension NicknameEditView {
    func setPlaceholderForTextField() {
        nicknameEditTextField.placeholder = { [weak self] in
            
            return self?.mypageView.getNicknameLabel().text
        }()
    }
    
    private func setupTextFieldDelegate() {
        nicknameEditTextField.delegate = self
    }
    
    private func setFirstResponderForTextField() {
        nicknameEditTextField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

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
}
