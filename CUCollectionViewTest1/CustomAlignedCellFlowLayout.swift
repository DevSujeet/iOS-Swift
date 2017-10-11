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
protocol CustomAlignedCellFlowLayoutProtocol {
    func heightForPacket(atIndex index:IndexPath) ->CGFloat
}
class CustomAlignedCellFlowLayout: UICollectionViewFlowLayout
{
    var flowAlignment:flowLayoutAlignment? = .normal
    
    override init() {
        super.init()
         let decorationNib = UINib(nibName: collectionViewInfo.packetDecorationViewNib, bundle: nil)
        self.register(decorationNib, forDecorationViewOfKind:collectionViewInfo.packetDecorationKind)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var allAttributes:[UICollectionViewLayoutAttributes] = []
        if let attrs = super.layoutAttributesForElements(in: rect)
        {
            //to add decoration view at section level
            //idea is to add a decoration view behind the whole section
            for attr in attrs {
                if attr.representedElementCategory == .supplementaryView {  //create adecorative atttribute for section
                    let packetDecorationAttr = self.layoutAttributesForDecorationView(ofKind: collectionViewInfo.packetDecorationKind, at: attr.indexPath) as! PacketDecorationViewLayoutAttributes//PacketDecorationViewLayoutAttributes(forDecorationViewOfKind: collectionViewInfo.packetDecorationKind, with: attr.indexPath)
                    
                    // Set the color(s)
                    if (attr.indexPath.section % 2 == 0) {
                        packetDecorationAttr.color = UIColor.green.withAlphaComponent(0.5)
                    } else {
                        packetDecorationAttr.color = UIColor.blue.withAlphaComponent(0.5)
                    }
                    
                    // Make the decoration view span the entire row - or whatever you want ;)
                    let tmpWidth = self.collectionView!.contentSize.width
                    let tmpHeight = self.itemSize.height + self.minimumLineSpacing + self.sectionInset.top / 2 + self.sectionInset.bottom / 2 // or attributes.frame.size.height instead of itemSize.height if dynamic or recalculated
                    let packetRect = CGRect(x: self.sectionInset.left, y: attr.frame.origin.y - self.sectionInset.top, width: tmpWidth, height: tmpHeight)
                    packetDecorationAttr.frame = packetRect
                    // Set the zIndex to be behind the item
                    packetDecorationAttr.zIndex = attr.zIndex - 1
                    // Add the attribute to the list
                    allAttributes.append(packetDecorationAttr)
                }
            }
            self.applyAlignmentSetting(attrs: attrs)
            
            allAttributes += attrs
        }
        return allAttributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            
            if elementKind == collectionViewInfo.packetDecorationKind {
                let atts = PacketDecorationViewLayoutAttributes(
                    forDecorationViewOfKind:collectionViewInfo.packetDecorationKind, with:indexPath)
                return atts
            }
            return nil
    }
    
    //MARK:- private function to set alignment of the cell.
    private func applyAlignmentSetting(attrs:[UICollectionViewLayoutAttributes]){
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
        }
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
