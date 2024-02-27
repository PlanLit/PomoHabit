//
//  FontLiterals.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

struct FontLiterals {
    private init() {}
    
    static func pretendardBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pretendardSemiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pretendardMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pretendardRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Regular", size: size) ?? .systemFont(ofSize: size)
    }
}
