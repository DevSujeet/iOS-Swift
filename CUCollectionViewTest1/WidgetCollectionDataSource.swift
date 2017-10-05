//
//  widgetCollectionDataSource.swift
//  collectionViewTest
//
//  Created by Sujeet.Kumar on 10/4/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation
import  UIKit

class WidgetCollectionDataSource:NSObject,UICollectionViewDataSource{
    let reuseIdentifier = "WidgetCollectionViewCell"
    var packetData:PacketData?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return (packetData?.widgets?.count == nil) ? 0: (packetData?.widgets?.count)!
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
    
}

extension WidgetCollectionDataSource : WidgetLayoutProtocol {
    
    func heightForWidget(at index: IndexPath) -> CGFloat {
        let widget = packetData?.widgets?[index.row]
        let height = widget?.height ?? 0
        return height
    }
}
