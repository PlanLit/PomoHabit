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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSelf()

        setAddSubviews()
        setAutoLayout()
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
                makeNextButton()
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
        textField.textColor = .pobitStone4
        textField.font = Pretendard.medium(size: 20)
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.pobitStone4])
        textField.addLeftPadding()
        textField.addRightPadding()
        
        return textField
    }
    
    private func makeNextButton() -> UIButton {
        let button = UIButton(type: .custom, primaryAction: .init(handler: { _ in
            let onboardingChattingViewController = OnboardingHabitRegistViewController()
            self.navigationController?.pushViewController(onboardingChattingViewController, animated: true)
        }))
        button.setImage(UIImage(named: "arrow"), for: .normal)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        return button
    }
        
    private func didTapSubmitButton() {
        let nickname = ""

        // 임시값
        let targetHabit = "Running"
        let targetDate = Date()
        let targetTime = Date()

        CoreDataManager.shared.createUser(nickname: nickname, targetHabit: targetHabit, targetDate: targetDate, targetTime: targetTime)
        
        // 닉네임 변경 테스트
        CoreDataManager.shared.updateUserNickname(to: "변경된 닉네임")
    }
}
