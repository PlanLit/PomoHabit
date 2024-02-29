//
//  UIViewController+Extension.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

extension UIViewController {
    
    func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func presentBottomSheet(rootView: UIView, delegate: UISheetPresentationControllerDelegate? = nil, detents: [UISheetPresentationController.Detent] = [.medium(), .large()], prefersGrabberVisible: Bool = true) {
        let viewController = BottomSheetViewController(rootView: rootView)
        if let sheet = viewController.sheetPresentationController {
            /// 지원할 크기 지정
            sheet.detents = detents
            /// delegate 설정
            sheet.delegate = delegate
            /// 시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = prefersGrabberVisible
        }
        
        present(viewController, animated: true, completion: nil)
    }
}
