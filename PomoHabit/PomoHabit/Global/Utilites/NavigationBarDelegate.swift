//
//  NavigationBarDelegate.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/21.
//

import UIKit

protocol NavigationBarDelegate: AnyObject {
    func didTapDismissButton()
}

extension NavigationBarDelegate where Self: UIViewController {
    func didTapDismissButton() {
        dismiss(animated: true)
    }
}
