//
//  BottomSheetPresentable.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import UIKit

/**
 .medium() - halfScreen
 .large() - fullScreen
 prefersGrabberVisible - 상단 중앙에 위치한 수평 바
 */

protocol BottomSheetPresentable:UIViewController, UISheetPresentationControllerDelegate {
    func presentBottomSheet(viewController: UIViewController, detents: [UISheetPresentationController.Detent], prefersGrabberVisible: Bool)
}

extension BottomSheetPresentable {
    func setupSheet(_ sheet: UISheetPresentationController, with detents: [UISheetPresentationController.Detent], prefersGrabberVisible: Bool) {
        sheet.delegate = self
        sheet.detents = detents
        sheet.prefersGrabberVisible = prefersGrabberVisible
    }
    
    func presentBottomSheet(viewController: UIViewController, detents: [UISheetPresentationController.Detent] = [.large()], prefersGrabberVisible: Bool = true) {
        let viewController = viewController
        viewController.view.backgroundColor = .pobitWhite
        
        guard let sheet = viewController.sheetPresentationController else { return }
        setupSheet(sheet, with: detents, prefersGrabberVisible: prefersGrabberVisible)
        
        present(viewController, animated: true)
    }
}
