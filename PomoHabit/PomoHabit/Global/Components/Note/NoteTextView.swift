//
//  NoteUITextView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/26/24.
//

import UIKit


// MARK: - NoteTextView

class NoteTextView: UITextView {
    private let placeHolderText = "메모를 입력해주세요."
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configureTextView()
        setTextViewDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension NoteTextView {
    private func configureTextView() {
        self.text = placeHolderText
        self.textColor = .gray
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.pobitStone4.cgColor //에셋 설정필요
        self.layer.masksToBounds = true
    }
}

// MARK: - Methods

extension NoteTextView {
    func getText() -> String {
        return self.text
    }
    
    func getPlaceholderText() -> String {
        return placeHolderText
    }
}

// MARK: - Delgate

extension NoteTextView {
    private func setTextViewDelegate() {
        self.delegate = self
    }
}

extension NoteTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = .black // 에셋 설정 필요
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolderText
            textView.textColor = .gray
        } else {
            UserDefaults.standard.set(textView.text, forKey: "noteText")
        }
    }
}
