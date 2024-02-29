//
//  OnboardingChattingViewController.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

import SnapKit

class OnboardingChattingViewController: UIViewController {
    
    // MARK: - Properties
    
    var messages = [Model(message: "안녕! 앱을 처음 실행해줘서 고마워!", chatType: .receive), Model(message: "나는 새로운 습관 형성을 도와줄 가이드야.", chatType: .receive), Model(message: "준비됐어?", chatType: .receive), Model(message: "응 준비됐어!", chatType: .send), Model(message: "어떤 습관을 만들고 싶어?", chatType: .receive)]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainTomato")
        
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .pobitSkin
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.pobitSkin
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OnboardingChattingCell.self, forCellWithReuseIdentifier: OnboardingChattingCell.identifier)
        
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension OnboardingChattingViewController {
    private func setAddSubviews() {
        view.addSubview(imageView)
        view.addSubview(collectionView)
    }
    
    private func setAutoLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingChattingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingChattingCell.identifier, for: indexPath) as? OnboardingChattingCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .pobitSkin
        cell.layer.cornerRadius = 20
        cell.chattingLabel.text = messages[indexPath.item].message
        cell.model = messages[indexPath.item]
        cell.bind()

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingChattingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
