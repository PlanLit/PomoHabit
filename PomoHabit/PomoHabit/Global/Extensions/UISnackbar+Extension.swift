//
//  UISnackbar+Extension.swift
//  PomoHabit
//
//  Created by 洪立妍 on 6/8/24.
//

import UIKit

import SnapKit

final class Snackbar {
    static func showSnackbar(in view: UIView, title: String, message: String) {
        let snackbarView = SnackbarView()
        snackbarView.updateContent(title: title, message: message)
        view.addSubview(snackbarView)
        
        snackbarView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(100)
            make.height.equalTo(100)
        }
        
        view.layoutIfNeeded() // 强制布局更新
        
        //animation 효과
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            snackbarView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-16)
            }
            view.layoutIfNeeded() // 在动画期间强制布局更新
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseInOut, animations: {
                snackbarView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(100)
                }
                view.layoutIfNeeded() // 在动画期间强制布局更新
            }, completion: { _ in
                snackbarView.removeFromSuperview()
            })
        })
    }
}

extension Snackbar {
    private class SnackbarView: UIView {
        private let titleLabel = UILabel()
        private let messageLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        //setupView는 SnackbarView 디자인
        private func setupView() {
            backgroundColor = UIColor.gray.withAlphaComponent(0.9)
            layer.cornerRadius = 8
            titleLabel.textColor = .white
            titleLabel.font = Pretendard.bold(size: 16)
            messageLabel.textColor = .white
            messageLabel.font = Pretendard.bold(size: 14)
            addSubview(titleLabel)
            addSubview(messageLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.leading.trailing.equalToSuperview().inset(10)
            }
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.leading.trailing.equalToSuperview().inset(10)
                make.bottom.equalToSuperview().offset(-10)
            }
        }
        //configure는 SnackbarView의 title 하고 message 내용
        func updateContent(title: String, message: String) {
            titleLabel.text = title
            messageLabel.text = message
        }
    }
}
