//
//  MemoView.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import Combine
import UIKit

import SnapKit

// MARK: - MemoView

final class MemoViewController: BaseViewController {

    // MARK: - UI Properties
    
    private lazy var navigationBar = PobitNavigationBarView(title: "메모", viewType: .withDismissButton)
    private lazy var textView = NoteTextView()
    private lazy var submitButton = PobitButton.makePlainButton(title: "등록하기", backgroundColor: .pobitRed)

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        setAddSubViews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension MemoViewController {
    private func setAddSubViews() {
        view.addSubViews([navigationBar, textView, submitButton])
    }
    
    private func setAutoLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(500)
            make.bottom.equalTo(submitButton.snp.top).inset(-68)
        }
        
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.leading.trailing.equalTo(textView)
            make.height.equalTo(62)
        }
    }
}
