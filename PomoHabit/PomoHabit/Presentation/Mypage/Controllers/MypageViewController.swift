//
//  MypageViewController.swift
//  PomoHabit
//
//  Created by 洪立妍 on 2/29/24.
//

import UIKit

// MARK: - MyPageViewController

final class MyPageViewController: UIViewController {

    // MARK: - Properties
    
    let myPageView = MyPageView()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myPageView)
        myPageView.frame = view.bounds
        myPageView.backgroundColor = .white
    }


    
    // MARK: - Action Helpers

        @objc func editButtonTapped() {
        }
    }

