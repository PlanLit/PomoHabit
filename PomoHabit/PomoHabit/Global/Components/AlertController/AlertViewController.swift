//
//  AlertViewController.swift
//  PomoHabit
//
//  Created by 최유리 on 2/27/24.
//

import UIKit

class AlertViewController: UIViewController {
    static func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
}
