//
//  UIViewController+Extension.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, cancelButton: Bool = true) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        
        if cancelButton {
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            alertController.addAction(cancelAction)
        }
        
        self.present(alertController, animated: true)
    }
}
