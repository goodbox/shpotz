//
//  RoundedBGLabel.swift
//  Spots
//
//  Created by Alexander Grach on 2/11/18.
//  Copyright © 2018 goodbox. All rights reserved.
//

import Foundation
import UIKit

class RoundedBGLabel : UILabel {
    
    var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = textInsets.apply(bounds)
        rect = super.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        return textInsets.inverse.apply(rect)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: textInsets.apply(rect))
    }
    
}


extension UIEdgeInsets {
    var inverse: UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }

    func apply(_ rect: CGRect) -> CGRect {
        
        // return rect.insetb
        return rect.inset(by: self)
        // return rect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10))
        
        // return CGRect.init(origin: rect.origin, size: rect.size)
        // return UIEdgeInsetsInsetRect(rect, self)
    }
}

