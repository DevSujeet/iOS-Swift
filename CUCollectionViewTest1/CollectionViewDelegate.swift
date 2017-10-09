//
//  CollectionViewDelegate.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/5/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDelegate:NSObject,UICollectionViewDataSource{
    let reuseIdentifier = "WidgetCollectionViewCell"
    let dataStore = DataStore()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataStore.totalCountOfDataElement()
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataStore.dataEntityCount(atSection: section)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
        cell.backgroundColor = UIColor.black
        // Configure the cell
        return cell
    }
    
    
    //    fileprivate var itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
    var holderViewFrame:CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
    var layoutInfo:ViewLayout?
}

extension CollectionViewDelegate:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthFactor:CGFloat = 1
        var itemsPerRow:CGFloat = 1
        
        let data = dataStore.dataAtIndex(index: indexPath)
        switch data {
        case .BotText( _):
            print("BotText")
        case .userText( _):
            print("userText")
        case .packet(let packetData):
            
            let widgetData = packetData.widgets![indexPath.row]
            
            let maxColoumnSpan = widgetData.widgetMaxColoumn
            let widgetLayout = widgetData.widgetLayout
            
            widthFactor = CGFloat( (widgetLayout?.colspan)! )/CGFloat( maxColoumnSpan! )
            itemsPerRow = CGFloat( (widgetLayout?.cellCountInRow)! )
        }
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = holderViewFrame.width - paddingSpace
        let widthPerItem = availableWidth  * widthFactor
        let height = heightForData(at: indexPath)
        
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
    
    func heightForData(at indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        let data = dataStore.dataAtIndex(index: indexPath)
        switch data {
        case .BotText( _):
            height = 60
        case .userText( _):
            height = 50
        case .packet(let packetData):
            let widgetData = packetData.widgets![indexPath.row]
            height = widgetData.height ?? 0
        }
        return height
    }
    
}
