//
//  BottomSheetViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/28.
//

import UIKit

import SnapKit

// MARK: - BottomSheetViewController

final class BottomSheetViewController: BaseViewController {

    private let containerView = WhiteNoiseView()
    private var bottomConstraint: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainerView()
        setupGesture()
    }
}

// MARK: - Setups

extension BottomSheetViewController {
    private func setupGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        containerView.addGestureRecognizer(gesture)
    }
}

// MARK: - Layout Helpers

extension BottomSheetViewController {
    private func setupContainerView() {
        view.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(300)
        }
    }
}

// MARK: - Action Helpers

extension BottomSheetViewController {
    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                bottomConstraint?.update(offset: 300 + translation.y)
            }
        case .ended:
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint?.update(offset: 300)
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
}
