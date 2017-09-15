//
//  DottedCircleView.swift
//  Tea
//
//  Created by Baglan on 7/14/16.
//  Copyright © 2016 Mobile Creators. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DashedCircleView: UIView {
    
    @IBInspectable var strokeWidth: CGFloat = 1 { didSet { setNeedsDisplay() } }
    @IBInspectable var dashSize: CGFloat = 1 { didSet { setNeedsDisplay() } }
    @IBInspectable var gapSize: CGFloat = 4 { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let shortestSize = min(bounds.width, bounds.height)
        let radius = (shortestSize - strokeWidth - 2) / 2
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.lineWidth = strokeWidth
        
        // Dashes
        let length = CGFloat.pi * radius * 2
        let numberOfSegments = Int(round(length / (dashSize + gapSize)))
        let sizeRatio = length / ((dashSize + gapSize) * CGFloat(numberOfSegments))
        let actualDashSize = dashSize * sizeRatio
        let actualGapSize = gapSize * sizeRatio
        
        let dashesPattern: [CGFloat] = [actualDashSize, actualGapSize]
        
        path.setLineDash(dashesPattern, count: 2, phase: 0)
        
        tintColor.setStroke()
        path.stroke()
    }
}
