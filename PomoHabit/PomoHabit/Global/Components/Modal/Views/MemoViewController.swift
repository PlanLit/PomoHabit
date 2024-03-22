//
//  MemoViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import Combine
import UIKit

import SnapKit

// MARK: - MemoViewController

final class MemoViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = PobitNavigationBarView(title: "메모", viewType: .withDismissButton)
    private lazy var textView = NoteTextView()
    private lazy var submitButton = PobitButton.makePlainButton(title: "등록하기", backgroundColor: .pobitRed)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        setDelegate()
        addButtonTarget()
        configureTextview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showSubmitButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // TODO: 키보드 내리는 제스처 지훈님 코드랑 익스텐션화 하기
        view.endEditing(true)
        hideSubmitButton()
    }
}

// MARK: - Settings

extension MemoViewController {
    private func setDelegate() {
        navigationBar.delegate = self
    }
    
    private func addButtonTarget() {
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
    }
    
    private func configureTextview() {
        if let savedText = UserDefaults.standard.string(forKey: "noteText"), !savedText.isEmpty {
            textView.text = savedText
            textView.textColor = .pobitBlack
        } else {
            textView.text = textView.getPlaceholderText()
            textView.textColor = .pobitStone4
        }
    }
}

// MARK: - Layout Helpers

extension MemoViewController {
    private func setAddSubViews() {
        view.addSubViews([navigationBar, textView, submitButton])
    }
    
    private func setAutoLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(218)
        }
        
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.leading.trailing.equalTo(textView)
            make.height.equalTo(62)
        }
    }
}

// MARK: - Action Helper

extension MemoViewController {
    private func showSubmitButton() {
        UIView.animate(withDuration: 0.2, animations: {
            self.submitButton.alpha = 1
        })
        submitButton.isHidden = false
    }
    
    private func hideSubmitButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.submitButton.alpha = 0
        }) { _ in
            self.submitButton.isHidden = true
        }
    }
}
