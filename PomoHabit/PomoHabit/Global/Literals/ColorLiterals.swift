//
//  ColorLiteral.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

extension UIColor {
    static var pobitRed: UIColor {
        return UIColor(hex: "#DA4646")
    }
    
    static var pobitRed2: UIColor {
        return UIColor(hex: "#FF5B5B")
    }
    
    static var pobitGreen: UIColor {
        return UIColor(hex: "#2E935D")
    }
    
    static var pobitWhite: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var pobitBlack: UIColor {
        return UIColor(hex: "#251A1B")
    }
    
    static var pobitStone0: UIColor {
        return UIColor(hex: "#4E4E4E")
    }
    
    static var pobitStone1: UIColor {
        return UIColor(hex: "#5B5B5B", alpha: 0.55)
    }
    
    static var pobitStone2: UIColor {
        return UIColor(hex: "#5B5B5B")
    }
    
    static var pobitStone3: UIColor {
        return UIColor(hex: "#C4C4C4")
    }
    
    static var pobitStone4: UIColor {
        return UIColor(hex: "#DEDEDE")
    }
    
    static var pobitStone5: UIColor {
        return UIColor(hex: "#6F6F7D")
    }
    
    static var pobitSkin: UIColor {
        return UIColor(hex: "#EFE9E7")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
