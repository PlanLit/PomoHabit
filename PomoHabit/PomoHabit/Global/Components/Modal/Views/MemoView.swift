//
//  MemoView.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import UIKit

import SnapKit

// MARK: - MemoView

final class MemoView: BaseView {

    // MARK: - UI Properties
    
    private lazy var navigationBar = PobitNavigationBarView(title: "메모")
    private lazy var textView = NoteTextView()
    private lazy var submitButton = PobitButton.makePlainButton(title: "등록하기", backgroundColor: .pobitRed)
    
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

extension MemoView {
    private func setAddSubViews() {
        addSubViews([navigationBar, textView, submitButton])
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
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.leading.trailing.equalTo(textView)
            make.height.equalTo(62)
        }
    }
    
}