//
//  BottomSheetPresentable.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import UIKit

protocol BottomSheetPresentable: UIViewController, UISheetPresentationControllerDelegate {
    func presentBottomSheet(rootView: UIView, detents: [UISheetPresentationController.Detent], prefersGrabberVisible: Bool)
}

extension BottomSheetPresentable {
    func presentBottomSheet(rootView: UIView, detents: [UISheetPresentationController.Detent] = [.large()], prefersGrabberVisible: Bool = true) {
        let viewController = BottomSheetViewController(rootView: rootView)
        
        guard let sheet = viewController.sheetPresentationController else { return }
        sheet.delegate = self
        sheet.detents = detents
        sheet.prefersGrabberVisible = prefersGrabberVisible
        
        present(viewController, animated: true)
    }
}
