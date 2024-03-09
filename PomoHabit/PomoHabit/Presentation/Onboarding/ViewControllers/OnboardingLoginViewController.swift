//
//  OnboardingLoginViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/8/24.
//

import UIKit

// MARK: - OnboardingFirstViewController

final class OnboardingLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var container: VStackView = makeContainer()
    private lazy var nextButton: UIButton = makeNextButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSelf()

        setAddSubviews()
        setAutoLayout()
//        didtapNextButton() // 임시로 만들어 놓은 함수입니다. 다음버튼 action연결해서 해당 함수 안에 있는 코드 사용하시면 됩니다.
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
            make.centerY.equalToSuperview().offset(-65)
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
            let onboardingChattingViewController = OnboardingHabitRegisterViewController()
            self.navigationController?.pushViewController(onboardingChattingViewController, animated: true)
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
        print("textFieldDidChangeSelection")
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

// MARK: - CoreData

extension OnboardingLoginViewController {
    func didtapNextButton() {
        // user 데이터 설정
        CoreDataManager.shared.createUser(nickname: "동진", targetHabit: "독서", targetDate: "월,화,수,목,금", startTime: "09 : 00 AM", whiteNoiseType: nil)
    }
}
