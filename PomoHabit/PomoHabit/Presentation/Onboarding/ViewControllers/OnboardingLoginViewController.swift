//
//  OnboardingLoginViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/8/24.
//

import UIKit

// MARK: - OnboardingFirstViewController

final class OnboardingLoginViewController: UIViewController {
    
    // MARK: - Data Properties
    
    private var nickname: String?
    
    // MARK: - UI Properties
    
    private lazy var container: VStackView = makeContainer()
    private lazy var nextButton: UIButton = makeNextButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSelf()

        setAddSubviews()
        setAutoLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Layout Helpers

extension OnboardingLoginViewController {
    private func setUpSelf() {
        view.backgroundColor = .pobitSkin
    }
    
    private func setAddSubviews() {
        view.addSubview(container)
    }
    
    private func setAutoLayout() {
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-65).priority(.low)
            make.bottom.lessThanOrEqualTo(self.view.keyboardLayoutGuide.snp.top).offset(-LayoutLiterals.minimumVerticalSpacing).priority(.medium)
        }
    }
}

// MARK: - Factory Methods

extension OnboardingLoginViewController {
    private func makeContainer() -> VStackView {
        return VStackView(spacing: 75, [
            makeMainImage(),
            HStackView(spacing: 8, alignment: .fill, [
                makeNicknameTextField(),
                nextButton
            ])
        ])
    }
    
    private func makeMainImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainTomato")
        imageView.snp.makeConstraints { make in
            make.width.equalTo(185)
            make.height.equalTo(185)
        }
        
        return imageView
    }
    
    private func makeNicknameTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.cornerRadius = 22
        textField.backgroundColor = .pobitWhite
        textField.font = Pretendard.medium(size: 20)
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.pobitStone4])
        textField.addLeftPadding()
        textField.addRightPadding()
        textField.delegate = self
        
        return textField
    }
    
    private func makeNextButton() -> UIButton {
        let button = UIButton(type: .custom, primaryAction: .init(handler: { _ in
            let onboardingHabitRegisterViewController = OnboardingHabitRegisterViewController()
            onboardingHabitRegisterViewController.setData(self.nickname)
            self.navigationController?.pushViewController(onboardingHabitRegisterViewController, animated: true)
        }))
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.layer.opacity = 0.5
        button.isUserInteractionEnabled = false
        button.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        return button
    }
}

// MARK: - UITextFieldDelegate

extension OnboardingLoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nickname = textField.text
        if textField.text != "" {
            nextButton.layer.opacity = 1
            nextButton.isUserInteractionEnabled = true
        } else {
            nextButton.layer.opacity = 0.5
            nextButton.isUserInteractionEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
