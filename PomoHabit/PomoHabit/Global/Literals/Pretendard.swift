//
//  FontLiterals.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

struct Pretendard {
    private init() {}
    
    static func bold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func semiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func medium(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func regular(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Regular", size: size) ?? .systemFont(ofSize: size)
    }
}
