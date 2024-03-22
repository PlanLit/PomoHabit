//
//  OpenSourceViewController.swift
//  PomoHabit
//
//  Created by 洪立妍 on 3/15/24.
//

import UIKit

import SnapKit

final class OpenSourceViewController: UIViewController {
    
    // MARK: - Properties
    
    private let openSourceTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textAlignment = .left
        textView.textColor = .pobitStone2
        textView.font = Pretendard.bold(size: 20)
        textView.text = """
        SnapKit
        
        https://github.com/SnapKit/SnapKit
        
        The MIT License
        Copyright (c) 2015
        Evgenii Neumerzhitckii
        
        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
        """
        return textView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setAddSubviews()
        setupConstraints()
    }
}

    // MARK: - Methods

    extension OpenSourceViewController {
    private func setAddSubviews() {
        view.addSubview(openSourceTextView)
    }
    
    private func setupConstraints() {
        openSourceTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
    }
}
