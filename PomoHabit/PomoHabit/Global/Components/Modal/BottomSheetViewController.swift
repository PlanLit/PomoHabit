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

    // MARK: - Properties
    
    private var bottomConstraint: Constraint?
    
    // MARK: - UI Properties
    
    private var rootView: UIView
    
    // MARK: - Life Cycle

    init(rootView: UIView) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGesture()
    }
}

// MARK: - Setups

extension BottomSheetViewController {
    private func setupContainerView() {
        rootView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.5) // 화면 높이의 절반
            bottomConstraint = make.bottom.equalToSuperview().constraint
        }
    }
    
    private func setupGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        rootView.addGestureRecognizer(gesture)
    }
}

// MARK: - Action Helpers

extension BottomSheetViewController {
    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: rootView)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                bottomConstraint?.update(inset: translation.y)
            }
        case .ended:
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint?.update(inset: 0)
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
}
