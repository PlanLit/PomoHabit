//
//  OnboardingChattingViewController.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

import SnapKit

// MARK: - OnboardingChattingViewController

final class OnboardingChattingViewController: UIViewController {
    // MARK: - Properties
    
    var messages = [Model(message: "안녕! 앱을 처음 실행해줘서 고마워!", chatType: .receive), Model(message: "나는 새로운 습관 형성을 도와줄 가이드야.", chatType: .receive), Model(message: "준비됐어?", chatType: .receive), Model(message: "응 준비됐어!", chatType: .send), Model(message: "어떤 습관을 만들고 싶어?", chatType: .receive), Model(message: "영단어 외우기", chatType: .send), Model(message: "무슨 요일에 할거야?", chatType: .receive), Model(message: "", chatType: .receive),Model(message: "몇시에 할거야?", chatType: .receive), Model(message: "AM 9:00마다 할게", chatType: .send)]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainTomato")
        
        return imageView
    }()
    
    private lazy var onboardingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .pobitSkin
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OnboardingChattingCell.self, forCellWithReuseIdentifier: OnboardingChattingCell.identifier)
        collectionView.register(DaysCollectionViewCell.self, forCellWithReuseIdentifier: DaysCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.pobitSkin
        
        setAddSubviews()
        setAutoLayout()
//        didtapNextButton() // 임시로 만들어 놓은 함수입니다. 다음버튼 action연결해서 해당 함수 안에 있는 코드 사용하시면 됩니다.
    }
}

// MARK: - Layout Helpers

extension OnboardingChattingViewController {
    private func setAddSubviews() {
        view.addSubViews([imageView, onboardingCollectionView])
    }
    
    private func setAutoLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(60)
        }
        
        onboardingCollectionView.snp.makeConstraints { make in
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
        
        if indexPath.item == 7 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DaysCollectionViewCell.identifier, for: indexPath) as? DaysCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        
        let model = messages[indexPath.item]
        cell.configureCell(with: model)
        cell.bind()
        
        print(indexPath.item)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingChattingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 7 {
            return CGSize(width: collectionView.frame.width, height: 100)
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
}

extension OnboardingChattingViewController {
    func didtapNextButton() {
        // user 데이터 설정
        CoreDataManager.shared.createUser(nickname: "동진", targetHabit: "독서", targetDate: "월,화,수,목,금", startTime: "09 : 00 AM", whiteNoiseType: nil)
    }
}
