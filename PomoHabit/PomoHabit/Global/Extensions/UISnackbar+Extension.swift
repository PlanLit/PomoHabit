//
//  UISnackbar+Extension.swift
//  PomoHabit
//
//  Created by 洪立妍 on 4/25/24.
//

import UIKit

final class Snackbar {
    static func showSnackbar(in view: UIView, title: String, message: String) {
        let snackbarView = SnackbarView(frame: CGRect(x: 0, y: -100, width: view.frame.width, height: 100))
        snackbarView.configure(title: title, message: message)
        view.addSubview(snackbarView)
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            snackbarView.frame.origin.y = 0
        }, completion: { _ in
            UIView.animate(withDuration: 2, delay: 2, options: .curveEaseInOut, animations: {
                snackbarView.frame.origin.y = -100
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
            configureView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureView() {
            backgroundColor = UIColor.gray.withAlphaComponent(0.9)
            layer.cornerRadius = 8
            
            titleLabel.textColor = .white
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            
            messageLabel.textColor = .white
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            
            
            addSubview(titleLabel)
            addSubview(messageLabel)
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
            }
            
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview().offset(-10)
            }
        }
        
        func configure(title: String, message: String) {
            titleLabel.text = title
            messageLabel.text = message
        }
    }
}
