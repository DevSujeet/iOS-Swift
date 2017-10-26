//
//  TopAlignedCollectionViewFlowLayout.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/9/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation
import UIKit

/// To define the cell layout with the row
///
/// - normal: to align the cell to center axis in the row
/// - top: to align the cell to top  in the row
/// - bottom: to align the cell to bottom axis in the row
enum flowLayoutAlignment {
    case normal
    case top
    case bottom
}

/// to delegate the fetching of packet information
protocol CustomAlignedCellFlowLayoutDelegate:NSObjectProtocol {
    func packetAtSection(section:Int) ->PacketData?
}

/// Custom alignned cell layout which align the cells along the axis of cell row
class CustomAlignedCellFlowLayout: UICollectionViewFlowLayout
{
    
    /// to describe the cell alignment along the row.
    var flowAlignment:flowLayoutAlignment? = .normal
    weak var customFlowDelegate:CustomAlignedCellFlowLayoutDelegate?
    override init() {
        super.init()
         let decorationNib = UINib(nibName: collectionViewInfo.packetDecorationViewNib, bundle: nil)
        self.register(decorationNib, forDecorationViewOfKind:collectionViewInfo.packetDecorationKind)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
     Note:- Never create Attribute here directly for any (cell, header(supplymentry), decorationview)
     use the
     layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
     func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
     layoutAttributeForSupplymentryView
     to create..a new attribute for any type based on the index information.
     
     as these methods can be asked to return attributes at a given index by the layout object.
     hence using the methods helps maintain the consistancy.
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var allAttributes:[UICollectionViewLayoutAttributes] = []
        if let attrs = super.layoutAttributesForElements(in: rect)
        {
            //to add decoration view at section level
            //idea is to add a decoration view behind the whole section
            for (index,attr) in attrs.enumerated() {
                
                allAttributes += attrs
                
                if attr.representedElementCategory == .decorationView{
                    allAttributes.remove(at: index)
                }
                if attr.representedElementCategory == .supplementaryView {  //create adecorative atttribute for section
                    let packetDecorationAttr = self.layoutAttributesForDecorationView(ofKind: collectionViewInfo.packetDecorationKind, at: attr.indexPath) as! PacketDecorationViewLayoutAttributes//PacketDecorationViewLayoutAttributes(forDecorationViewOfKind: collectionViewInfo.packetDecorationKind, with: attr.indexPath)

                    allAttributes.append(packetDecorationAttr)
                }
            }
            self.applyAlignmentSetting(attrs: attrs)
            
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at:indexPath)
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            
                if elementKind == collectionViewInfo.packetDecorationKind {
                    let packetDecorationAttr = PacketDecorationViewLayoutAttributes(
                        forDecorationViewOfKind:collectionViewInfo.packetDecorationKind, with:indexPath)
                    
                    let attr = self.layoutAttributesForItem(at: indexPath)! //the attribute is of the cell
                    let sectionAttr = self.layoutAttributesForSupplementaryView(ofKind: "", at: indexPath)
                    // Set the color(s)
                    if (attr.indexPath.section % 2 == 0) {
                        packetDecorationAttr.color = UIColor.green.withAlphaComponent(0.5)
                    } else {
                        packetDecorationAttr.color = UIColor.blue.withAlphaComponent(0.5)
                    }
                    
                    // Make the decoration view span the entire row - or whatever you want ;)
                    var tmpWidth = self.collectionView!.contentSize.width
                    var tmpHeight = CGFloat(0)
                    if let packet = self.customFlowDelegate?.packetAtSection(section: attr.indexPath.section) {
                        let widgetCount = packet.widgets?.count
                        let lastCellInSectionIndexPath = IndexPath(row: widgetCount! - 1, section: attr.indexPath.section)
                        let lastCellAttribute = self.layoutAttributesForItem(at: lastCellInSectionIndexPath)
                        let lastCellFrame = lastCellAttribute?.frame
                        tmpHeight = (lastCellFrame?.origin.y)! - attr.frame.origin.y + (lastCellFrame?.size.height)!
                        tmpWidth = (lastCellFrame?.size.width)!
                    }
                    
                    let packetRect = CGRect(x: self.sectionInset.left - PacketDecorationInfo.padding, y: attr.frame.origin.y - PacketDecorationInfo.padding - SectionHeaderInfo.headerHeight , width: tmpWidth + (2 * PacketDecorationInfo.padding), height: tmpHeight + (2 * PacketDecorationInfo.padding) + SectionHeaderInfo.headerHeight)
                    
                    packetDecorationAttr.frame = packetRect
                    // Set the zIndex to be behind the item
                    packetDecorationAttr.zIndex = attr.zIndex - 1
                    
                    return packetDecorationAttr
                }
            
           
            return nil
    }
    
    //MARK:- private function to set alignment of the cell.
    private func applyAlignmentSetting(attrs:[UICollectionViewLayoutAttributes]){
        if flowAlignment != .normal {
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
