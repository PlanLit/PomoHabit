//
//  String+Extension.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

extension String {
    func getEstimatedFrame(with font: UIFont) -> CGRect {
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options, attributes: [.font: font], context: nil)
        
        return estimatedFrame
    }
}
