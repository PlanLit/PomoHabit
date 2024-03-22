//
//  UIViewController+Extension.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String?, cancelButton: Bool = true, actionHandler:((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: actionHandler)
        alertController.addAction(confirmAction)
        
        if cancelButton {
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            alertController.addAction(cancelAction)
        }
        
        self.present(alertController, animated: true)
    }
    
    @objc func didTapSubmitButton() {
        dismiss(animated: true)
    }
}
