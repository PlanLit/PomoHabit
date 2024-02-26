//
//  UITextField+Extension.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

extension UITextField {
    
    func addLetPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
    
}
