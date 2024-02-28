//
//  HabbitInfoVIew.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

// MARK: - HabbitInfoView

final class HabbitInfoView: UIView {
    
    // MARK: - Properties
    
    private lazy var titleInfoView: ImageViewAndLabelView = {
        let stackView = ImageViewAndLabelView()
        stackView.setUplabel(text: "독서", font: Pretendard.bold(size: 20))
        
        return stackView
    }()
    
    private lazy var timeInfoView: ImageViewAndLabelView = {
        let stackView = ImageViewAndLabelView()
        stackView.setUplabel(text: "09:00 ~ 09:05", font: Pretendard.medium(size: 15))
        stackView.setUIImageViewImage(image: UIImage(named: "TimeImage"))
        
        return stackView
    }()
    
    private lazy var targetInfoView: ImageViewAndLabelView = {
        let stackView = ImageViewAndLabelView()
        stackView.setUplabel(text: "목표시간 : 5m", font: Pretendard.medium(size: 15))
        stackView.setUIImageViewImage(image: UIImage(named: "TargetImage"))
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension HabbitInfoView {
    private func setAddSubViews() {
        self.addSubViews([titleInfoView,timeInfoView,targetInfoView])
        
    }
    
    private func setAutoLayout() {
        titleInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        timeInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleInfoView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        targetInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleInfoView.snp.bottom).offset(12)
            make.leading.equalTo(timeInfoView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func setUpView() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.pobitStone4.cgColor
    }
}

// MARK: - Methods

extension HabbitInfoView {
    func setTitleInfoViewImage(state: HabbitState) {
        titleInfoView.setUIImageViewImage(image: state.image)
    }
}
