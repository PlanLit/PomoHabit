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
    
    // 질문별로 스텝 나눔
    enum QuestionStep {
        case first
        case second
        case third
    }
    // 초기값 first
    private var currentStep: QuestionStep = .first
    
    var messages = [Model(message: "안녕! 앱을 실행해줘서 고마워!", chatType: .receive), Model(message: "나는 새로운 습관 형성을 도와줄 가이드야.", chatType: .receive), Model(message: "어떤 습관을 만들고 싶어?", chatType: .receive), Model(message: "", chatType: .send), Model(message: "무슨 요일에 할거야?", chatType: .receive), Model(message: "", chatType: .receive), Model(message: "몇시에 할거야?", chatType: .receive), Model(message: "", chatType: .send)]
    
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
    
    private let habbitTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "습관 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.pobitStone3])
        textField.addLeftPadding()
        textField.backgroundColor = .white
        textField.isHidden = true
        
        return textField
    }()
    
    private let habbitSaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.pobitWhite, for: .normal)
        button.backgroundColor = .pobitBlack
//        button.addTarget(OnboardingChattingViewController.self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.isHidden = true
        
        return datePicker
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.pobitSkin
        habbitSaveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension OnboardingChattingViewController {
    private func setAddSubviews() {
        view.addSubViews([imageView, onboardingCollectionView, habbitTextField, habbitSaveButton, datePicker])
    }
    
    private func setAutoLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.snp.leading).inset(10)
            make.width.height.equalTo(60)
        }
        
        onboardingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        habbitTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-70)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(50)
        }
        
        habbitSaveButton.snp.makeConstraints { make in
            make.leading.equalTo(habbitTextField.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(50)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

// MARK: - UICollectionViewDataSource

///  1. 원하는 셀을 감추거나 보이는 게 자유자재로 되어야함
///  2. 트리거를 가지고 실제로 감추고 보이는 것을 해봄
///  3. 마지막 트리거를 눌렀을 때 실제로 저장함

extension OnboardingChattingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingChattingCell.identifier, for: indexPath) as? OnboardingChattingCell else {
            return UICollectionViewCell()
        }
        
        currentStep = (indexPath.item == 4 && indexPath.item == 5) ? .second : currentStep
        currentStep = (indexPath.item == 6 && indexPath.item == 7) ? .third : currentStep
        
        // .first가 아니라면 isHidden = true, 입력 완료 됐다면 sender에 입력한 값 보여주기
        // .second
        
        if currentStep == .first {
            habbitTextField.isHidden = false
            habbitTextField.becomeFirstResponder()
        }
        
        if indexPath.item == 5 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DaysCollectionViewCell.identifier, for: indexPath) as? DaysCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
        
        if currentStep == .third {
            habbitSaveButton.isHidden = true
            datePicker.isHidden = false
        }
        
        let model = messages[indexPath.item]
        cell.configureCell(with: model)
        cell.bind()
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingChattingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // indexPath.item == 5는 요일셀
        if indexPath.item == 5 {
            return CGSize(width: collectionView.frame.width, height: 100)
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
}

// MARK: - Action Helpers

extension OnboardingChattingViewController {
    @objc private func didTapSaveButton() {
        // 확인버튼 눌렀을 때 텍스트필드의 값을 messages로
        if let text = habbitTextField.text, !text.isEmpty {
            messages[3].message = text
            print(messages[3].message)
        }
        habbitTextField.text = ""
        currentStep = .second
    }
    
    @objc private func dateChange(_ sender: UIDatePicker) {
        
    }
}

