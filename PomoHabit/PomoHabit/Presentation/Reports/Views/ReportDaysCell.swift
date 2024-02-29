//
//  ReportDaysCell.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/29/24.
//

import UIKit

// MARK: - ReportDaysCell

final class ReportDaysCell: UITableViewCell {
    private var collectionViewCellID = "\(ReportDaysCell.self)CollectionViewCell"
    
    var collectionView: UICollectionView!
    
    let dayStates: [DayButton.Day] = [.mon, .tue, .wed, .thu, .fri, .sat, .sun]
    
    var buttonSelectionStates: [Bool]?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setUpSelf()
        setUpCollectionView()
        
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension ReportDaysCell {
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
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellID)
    }
    
    private func setAddSubviews() {
        contentView.addSubview(collectionView)
    }
    
    private func setAutoLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ReportDaysCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath)
        
        let dayButton = DayButton(dayType: dayStates[indexPath.row], isSelected: buttonSelectionStates?[indexPath.row] ?? false) { _ in }
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
