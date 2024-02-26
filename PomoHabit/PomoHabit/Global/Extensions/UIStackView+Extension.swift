//
//  UIStackView+Extension.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ views : [UIView]) {
    _ = views.map { self.addArrangedSubview($0) }
  }
}
