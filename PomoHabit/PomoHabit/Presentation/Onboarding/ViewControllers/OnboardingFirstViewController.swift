//
//  OnboardingFirstViewController.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

import SnapKit

// MARK: - OnboardingFirstViewController

class OnboardingFirstViewController: UIViewController {
    
    // MARK: - Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainTomato")
        imageView.frame.size = CGSize(width: 185, height: 185)
        
        return imageView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.pobitWhite
        textField.layer.cornerRadius = 22
        textField.addLeftPadding()
        textField.addRightPadding()
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.pobitStone4])
        
        return textField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow"), for: .normal)
        
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.pobitSkin

        setAddSubviews()
        setAutoLayout()
        
        button.addTarget(self, action: #selector(tappedSubmitButton), for: .touchUpInside)
    }
}

// MARK: - Layout Helpers

extension OnboardingFirstViewController {
    private func setAddSubviews() {
        view.addSubview(imageView)
        view.addSubview(textField)
        view.addSubview(button)
    }
    
    private func setAutoLayout() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(136)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(96)
            make.leading.equalTo(view.snp.leading).inset(89)
            make.height.equalTo(button.snp.height)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(96)
            make.leading.equalTo(textField.snp.trailing).offset(8)
        }
    }
}

// MARK: - Action Helpers

extension OnboardingFirstViewController {
    @objc private func tappedSubmitButton() {
        let nextViewController = OnboardingChattingViewController()
        self.present(nextViewController, animated: true)
    }
}
