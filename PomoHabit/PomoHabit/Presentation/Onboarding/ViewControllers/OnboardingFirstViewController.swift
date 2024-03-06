//
//  OnboardingFirstViewController.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

// MARK: - OnboardingFirstViewController

final class OnboardingFirstViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var mainImage: UIImageView = makeMainImage()
    
    private lazy var nicknameTextField: UITextField = makeNicknameTextField()
    
    private lazy var saveButton: UIButton = makeSaveButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSelf()

        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension OnboardingFirstViewController {
    private func setUpSelf() {
        view.backgroundColor = .pobitSkin
    }
    
    private func setAddSubviews() {
        view.addSubViews([mainImage, nicknameTextField, saveButton])
    }
    
    private func setAutoLayout() {
        mainImage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(136)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(96)
            make.leading.equalTo(view.snp.leading).inset(89)
            make.height.equalTo(saveButton.snp.height)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(96)
            make.leading.equalTo(nicknameTextField.snp.trailing).offset(8)
        }
    }
}

// MARK: - Factory Methods

extension OnboardingFirstViewController {
    private func makeNicknameTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = .pobitWhite
        textField.layer.cornerRadius = 22
        textField.addLeftPadding()
        textField.addRightPadding()
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.pobitStone4])
        
        return textField
    }
    
    private func makeMainImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainTomato")
        imageView.frame.size = CGSize(width: 185, height: 185)
        
        return imageView
    }
    
    private func makeSaveButton() -> UIButton {
        let button = UIButton(type: .custom, primaryAction: .init(handler: { _ in
            let onboardingChattingViewController = OnboardingChattingViewController()
            self.navigationController?.pushViewController(onboardingChattingViewController, animated: true)
        }))
        
        button.setImage(UIImage(named: "arrow"), for: .normal)
        
        return button
    }
}
