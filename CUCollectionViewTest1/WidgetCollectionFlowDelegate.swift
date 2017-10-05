//
//  WidgetCollectionFlowDelegate.swift
//  collectionViewTest
//
//  Created by Sujeet.Kumar on 10/4/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation
import UIKit

protocol WidgetLayoutProtocol:NSObjectProtocol {
    func heightForWidget(at index:IndexPath) ->CGFloat
}

class WidgetCollectionFlowDelegate:NSObject, UICollectionViewDelegateFlowLayout {
    
//    fileprivate var itemsPerRow: CGFloat = 3
    weak var widgetLayoutDelegate:WidgetLayoutProtocol?
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var holderViewFrame:CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
    var layoutInfo:ViewLayout?
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxColoumnSpan = layoutInfo?.columns
        let widgetLayout = layoutInfo?.widgets?[indexPath.row]
        
        let widthFactor = CGFloat( (widgetLayout?.colspan)! )/CGFloat( maxColoumnSpan! )
        let itemsPerRow = CGFloat((layoutInfo?.indexRowCountInfo[indexPath.row])! )
        
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = holderViewFrame.width - paddingSpace
        let widthPerItem = availableWidth  * widthFactor
        let height = widgetLayoutDelegate?.heightForWidget(at: indexPath) ?? 0
        
        return CGSize(width: widthPerItem, height: height)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
