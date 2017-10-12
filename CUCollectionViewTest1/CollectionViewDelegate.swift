//
//  CollectionViewDelegate.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/5/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation
import UIKit

struct collectionViewInfo {
    static let headerViewKind = UICollectionElementKindSectionHeader
    static let headerReuseIdentifier = "PacketSectionViewIdentifier"
    
//use the decorationKind as the reuse identifier in the decoration NIB.
    static let packetDecorationKind = "packetDecorationKind"
    static let packetDecorationViewNib = "PacketDecorationView"
    
    //cell identifier
    static let widgetReuseIdentifier = "WidgetCollectionViewCell"
    static let botChatCellIdentifier = "botChatCell"
    static let userChatCellIdentifier = "userChatCell"
}

class CollectionViewDelegate:NSObject,UICollectionViewDataSource {

    
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
        let dataType = self.dataStore.dataAtIndex(index: indexPath)
        switch dataType {
        case .packet(_ ):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewInfo.widgetReuseIdentifier,
                                                          for: indexPath)
            cell.backgroundColor = UIColor.black
            // Configure the cell
            return cell
        case.BotText(let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewInfo.botChatCellIdentifier,for: indexPath) as! BotChatCollectionViewCell
            cell.chatLabel.text = text
            cell.backgroundColor = UIColor.purple
            // Configure the cell
            return cell
        case .userText(let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewInfo.userChatCellIdentifier,for: indexPath) as! UserChatCollectionViewCell
            cell.backgroundColor = UIColor.yellow
            cell.chatLabel.text = text
            // Configure the cell
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewInfo.headerReuseIdentifier, for: indexPath) as! PacketSectionView
        headerView.sectionTitleLabel.text = "header"
        return headerView
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let data = dataStore.dataAt(section: section)
        switch data {
        case .packet(_):
            //width doesnt have effect in the collection header se=ize for vertical scroll.
            let width = UIScreen.main.bounds.width - 200//(self.sectionInsets.left * 2)
            return CGSize(width: width, height: 50)
        default:
            return CGSize(width: 0, height: 0)
        }
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
    
    func heightForPacket(at indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    //MARk:- data source update
    func addData() {
        dataStore.addData()
        
    }
    
    func deleteData() {
        dataStore.deleteData()
    }
}

extension CollectionViewDelegate: CustomAlignedCellFlowLayoutDelegate {
    func packetAtSection(section: Int) -> PacketData? {
        let dataType = dataStore.dataAt(section: section)
        switch dataType {
        case .packet(let packetData):
            return packetData
        default:
            return nil
        }
    }
}
