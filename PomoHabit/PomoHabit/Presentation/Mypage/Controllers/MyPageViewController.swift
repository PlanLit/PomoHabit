//
//  MyPageViewController.swift
//  PomoHabit
//
//  Created by 洪立妍 on 2/27/24.
//

import UIKit

import SnapKit

class MyPageViewController: UIViewController {
    var customLabel: CustomLabel = CustomLabel()
    //    let customLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        customLabel.setRedLabel(text: "Date")
        customLabel.edgeInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.backgroundColor = .white
        view.addSubview(customLabel)
        customLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

