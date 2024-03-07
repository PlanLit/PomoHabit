//
//  OnboardingProfilePictureTableViewCell.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/7/24.
//

import UIKit

final class OnboardingProfilePictureTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var profileImageView: UIImageView = makeMainImage()
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpSelf()
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension OnboardingProfilePictureTableViewCell {
    private func setUpSelf() {
        self.backgroundColor = .clear
    }
    
    private func setAddSubviews() {
        contentView.addSubview(profileImageView)
    }
    
    private func setAutoLayout() {
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(73)
            make.height.equalTo(73)
            make.leading.equalTo(contentView.snp.leading).offset(LayoutLiterals.minimumHorizontalSpacing)
        }
    }
}

// MARK: - Factory Methods

extension OnboardingProfilePictureTableViewCell {
    private func makeMainImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainTomato")
        
        return imageView
    }
}
