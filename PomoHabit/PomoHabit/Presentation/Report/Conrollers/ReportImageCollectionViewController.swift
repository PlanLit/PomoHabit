//
//  ReportImageCollectionViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/28/24.
//

import UIKit

// MARK: - ReportImageCollectionViewController

final class ReportImageCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let cellID = "reportImageCell"
    private let itemSize: CGFloat = 100.0 - 18.0
    private var centeredItemIndex: IndexPath = [0, 0]
    private var habitAcheivementRate: Int = 0
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setUpCollectionViewFlowLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpCollectionViewFlowLayout()
    }
}

// MARK: - Layout Helpers

extension ReportImageCollectionViewController {
    private func setUpCollectionView() {
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .normal
    }
    
    private func setUpCollectionViewFlowLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: itemSize, height: itemSize)
            layout.minimumLineSpacing = CGFloat(LayoutLiterals.upperSecondarySpacing)
            let inset = (view.frame.width - layout.itemSize.width) / 2
            layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
    }
    
    private func configureCell(_ cell: UICollectionViewCell, for indexPath: IndexPath) {
        let circleGaugeImageView = CircleGaugeImageView(frame: cell.bounds)
        circleGaugeImageView.setProgress(to: CGFloat(habitAcheivementRate)/CGFloat(100), withAnimation: true)
        circleGaugeImageView.setImage(.tomatoCharacter)
        
        if indexPath != centeredItemIndex {
            let reducedSize = itemSize-(itemSize/7)
            circleGaugeImageView.frame.size = .init(width: reducedSize, height: reducedSize)
            circleGaugeImageView.alpha = 0.5
        }
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(circleGaugeImageView)
    }
    
    func setData(_ habitAcheivementRate: Int) {
        self.habitAcheivementRate = habitAcheivementRate
    }
}

// MARK: - UICollectionViewDataSource

extension ReportImageCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        configureCell(cell, for: indexPath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ReportImageCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 토마토 누르기 구현 할거라 미리 작성
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let pageWidth = layout.itemSize.width + layout.minimumLineSpacing
        let currentOffset = scrollView.contentOffset.x
        let targetOffset = targetContentOffset.pointee.x
        var newTargetOffset: CGFloat = 0
        
        if targetOffset > currentOffset {
            newTargetOffset = ceil(currentOffset / pageWidth) * pageWidth
        } else {
            newTargetOffset = floor(currentOffset / pageWidth) * pageWidth
        }
        
        if newTargetOffset > scrollView.contentSize.width - scrollView.bounds.width {
            newTargetOffset = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        targetContentOffset.pointee.x = newTargetOffset
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: center) {
            centeredItemIndex = indexPath
            for cell in collectionView.visibleCells {
                guard let indexPath = collectionView.indexPath(for: cell) else { continue }
                configureCell(cell, for: indexPath)
            }
        }
    }
}
