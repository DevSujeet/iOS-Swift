//
//  TopAlignedCellFlowLayout.swift
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
    case left
    case bottom
    case right
}

class CustomAlignedCellFlowLayout:UICollectionViewFlowLayout {
    var alignment:flowLayoutAlignment?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        for attribute in attributes! {
            attribute.frame = (self.layoutAttributesForItem(at: attribute.indexPath)?.frame)!
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attribute:UICollectionViewLayoutAttributes?
        switch self.alignment! {
        case .bottom :
            print("cell alignment bottom.")
        case .top :
            print("cell alignment top.")
            attribute = layoutAttributesForTopAlignmentForItem(atIndexPath: indexPath)
        case .left :
            print("cell alignment left.")
            attribute = layoutAttributesForLeftAlignmentForItem(atIndexPath: indexPath)
        case .right :
            print("cell alignment right.")
        
        case .normal:
            print("cell alignment normal.")
            attribute = super.layoutAttributesForItem(at: indexPath)
        }
        return attribute
    }

    func layoutAttributesForLeftAlignmentForItem(atIndexPath indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes:UICollectionViewLayoutAttributes = super.layoutAttributesForItem(at: indexPath)!
        var frame = attributes.frame
        
        if attributes.frame.origin.x <= self.sectionInset.left {
            return attributes
        }
        
        if indexPath.item == 0 {
            frame.origin.x = self.sectionInset.left
        }else{
            let previousIndexPath = IndexPath(item: indexPath.row - 1, section: indexPath.section)
            let previousAttributes = self.layoutAttributesForItem(at: previousIndexPath)//self.layoutAttributesForItem(at: previousIndexPath)!
            
            if (attributes.frame.origin.y > (previousAttributes?.frame.origin.y)!) {
                frame.origin.x = self.sectionInset.left;
            } else {
                frame.origin.x = (previousAttributes?.frame.maxX)! + self.minimumInteritemSpacing
            }
        }
        
        attributes.frame = frame
        
        return attributes
    }
    
    func layoutAttributesForTopAlignmentForItem(atIndexPath indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes:UICollectionViewLayoutAttributes = super.layoutAttributesForItem(at: indexPath)!
        var frame = attributes.frame
        if attributes.frame.origin.y <= self.sectionInset.top {
            return attributes
        }
        
        if indexPath.item == 0 {
            frame.origin.y = self.sectionInset.top;
        }else {
            let previousIndexPath = IndexPath(item: indexPath.row - 1, section: indexPath.section)
            let previousAttributes = self.layoutAttributesForItem(at: previousIndexPath)//self.layoutAttributesForItem(at: previousIndexPath)!
            
            if (attributes.frame.origin.x > (previousAttributes?.frame.origin.x)!) {
                frame.origin.y = self.sectionInset.top;
            } else {
                frame.origin.y = (previousAttributes?.frame.maxY)! + self.minimumInteritemSpacing
            }
            
        }
        
        attributes.frame = frame
        
        return attributes
    }
}
