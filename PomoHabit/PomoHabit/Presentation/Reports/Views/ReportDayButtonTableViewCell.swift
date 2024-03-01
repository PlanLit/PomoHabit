//
//  ReportDayButtonCell.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/29/24.
//

import UIKit

// MARK: - ReportDaysCell

final class ReportDayButtonTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var collectionViewCellID = "\(ReportDayButtonTableViewCell.self)CollectionViewCell"
    
    private var dayButtonCollectionView: UICollectionView!
    
    private let dayStates: [DayButton.Day] = [.mon, .tue, .wed, .thu, .fri, .sat, .sun]
    
    var dayButtonSelectionStates: [Bool]?
    
    // MARK: - Life Cycles

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setUpSelf()
        setUpCollectionView()
        
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension ReportDayButtonTableViewCell {
    private func setUpSelf() {
        self.selectionStyle = .none
    }
    
    private func setUpCollectionView() {
        let layout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 65, height: 65)
            layout.minimumLineSpacing = 10
            
            return layout
        }()
        
        dayButtonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dayButtonCollectionView.dataSource = self
        dayButtonCollectionView.showsHorizontalScrollIndicator = false
        dayButtonCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellID)
    }
    
    private func setAddSubviews() {
        contentView.addSubview(dayButtonCollectionView)
    }
    
    private func setAutoLayout() {
        dayButtonCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ReportDayButtonTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath)
        
        let dayButton = DayButton(dayType: dayStates[indexPath.row], isSelected: dayButtonSelectionStates?[indexPath.row] ?? false) { _ in }
        dayButton.isUserInteractionEnabled = false
        dayButton.snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(65)
        }
    
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(dayButton)
        
        return cell
    }
}
