//
//  UIView+Extension.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

extension UIView {
  func addSubViews(_ views : [UIView]) {
    _ = views.map { self.addSubview($0) }
  }
}
