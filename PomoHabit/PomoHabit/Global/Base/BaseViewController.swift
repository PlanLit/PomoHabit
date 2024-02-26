//
//  BaseViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
    }
    
    deinit {
        print("\(self) is being deinitialized")
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
}
