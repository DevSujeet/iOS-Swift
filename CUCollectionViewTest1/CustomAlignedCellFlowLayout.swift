//
//  TopAlignedCollectionViewFlowLayout.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/9/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation
import UIKit

enum flowLayoutAlignment {
    case normal
    case top
    case bottom
}

class CustomAlignedCellFlowLayout: UICollectionViewFlowLayout
{
    var flowAlignment:flowLayoutAlignment? = .normal
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        
        if let attrs = super.layoutAttributesForElements(in: rect)
        {
            if .normal != flowAlignment {
                var baseline: CGFloat = -2
                var sameLineElements = [UICollectionViewLayoutAttributes]()
                for element in attrs
                {
                    if element.representedElementCategory == .cell
                    {
                        let frame = element.frame
                        let centerY = frame.midY
                        if abs(centerY - baseline) > 1
                        {
                            baseline = centerY
                            alignToCellForSameLineElements(sameLineElements: sameLineElements)
                            sameLineElements.removeAll()
                        }
                        sameLineElements.append(element)
                    }
                }
                alignToCellForSameLineElements(sameLineElements: sameLineElements) // align one more time for the last line
                return attrs
            }
            
        }
        return nil
    }
    
    private func alignToCellForSameLineElements(sameLineElements: [UICollectionViewLayoutAttributes])
    {
        if sameLineElements.count < 1
        {
            return
        }
        let sorted = sameLineElements.sorted { (obj1: UICollectionViewLayoutAttributes, obj2: UICollectionViewLayoutAttributes) -> Bool in
            
            let height1 = obj1.frame.size.height
            let height2 = obj2.frame.size.height
            let delta = height1 - height2
            return delta <= 0
        }
        if let tallest = sorted.last
        {
            for obj in sameLineElements
            {
                setOffestForAlignment(withTallest: tallest, targetObj: obj)
            }
        }
    }
    
    private func setOffestForAlignment(withTallest tallest:UICollectionViewLayoutAttributes, targetObj:UICollectionViewLayoutAttributes) {
        
        switch self.flowAlignment! {
        case .bottom:
            targetObj.frame = targetObj.frame.offsetBy(dx: 0,dy: targetObj.frame.origin.y - tallest.frame.origin.y )
        case .top:
            targetObj.frame = targetObj.frame.offsetBy(dx: 0,dy: tallest.frame.origin.y - targetObj.frame.origin.y)
        default:
            print("Do nothing")
        }
        
    }
}
