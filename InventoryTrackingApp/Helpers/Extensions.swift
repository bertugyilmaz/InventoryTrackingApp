//
//  Extensions.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 8.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit
enum UIImageAlignment {
    case Center, Left, Top, Right, Bottom, TopLeft, BottomRight, BottomLeft, TopRight
}

extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }

}


enum UIImageScaleMode {
    case Fill,
    AspectFill,
    AspectFit(UIImageAlignment)
}

extension UIImage {
    func scaleImage(width: CGFloat? = nil, height: CGFloat? = nil, scaleMode: UIImageScaleMode = .AspectFit(.Center), trim: Bool = false) -> UIImage {
        let preWidthScale = width.map { $0 / size.width }
        let preHeightScale = height.map { $0 / size.height }
        var widthScale = preWidthScale ?? preHeightScale ?? 1
        var heightScale = preHeightScale ?? widthScale
        switch scaleMode {
        case .AspectFit(_):
            let scale = min(widthScale, heightScale)
            widthScale = scale
            heightScale = scale
        case .AspectFill:
            let scale = max(widthScale, heightScale)
            widthScale = scale
            heightScale = scale
        default:
            break
        }
        let newWidth = size.width * widthScale
        let newHeight = size.height * heightScale
        let canvasWidth = trim ? newWidth : (width ?? newWidth)
        let canvasHeight = trim ? newHeight : (height ?? newHeight)
        let graphSize = CGSize(width: canvasWidth, height: canvasHeight)
        UIGraphicsBeginImageContextWithOptions(graphSize, false,0)
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        switch scaleMode {
        case .AspectFit(let alignment):
            switch alignment {
            case .Center:
                originX = (canvasWidth - newWidth) / 2
                originY = (canvasHeight - newHeight) / 2
            case .Top:
                originX = (canvasWidth - newWidth) / 2
            case .Left:
                originY = (canvasHeight - newHeight) / 2
            case .Bottom:
                originX = (canvasWidth - newWidth) / 2
                originY = canvasHeight - newHeight
            case .Right:
                originX = canvasWidth - newWidth
                originY = (canvasHeight - newHeight) / 2
            case .TopLeft:
                break
            case .TopRight:
                originX = canvasWidth - newWidth
            case .BottomLeft:
                originY = canvasHeight - newHeight
            case .BottomRight:
                originX = canvasWidth - newWidth
                originY = canvasHeight - newHeight
            }
        default:
            break
        }
        let drawRect = CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
        self.draw(in: drawRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
