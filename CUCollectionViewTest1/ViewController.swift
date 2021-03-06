//
//  ViewController.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/5/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import UIKit

struct controllerSetting {
    
    /// describe the cell alignment in the collectionview
    static let cellAlignmnet = flowLayoutAlignment.top
    
}

class ViewController: UIViewController {
    let collectionDelegate = CollectionViewDelegate()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            //register the collection with the cell it is going to use.
            let widgetCellNib = UINib(nibName: "WidgetCollectionViewCell", bundle: nil)
            collectionView.register(widgetCellNib, forCellWithReuseIdentifier: collectionViewInfo.widgetReuseIdentifier)
            
            let botCellNib = UINib(nibName: "BotChatCollectionViewCell", bundle: nil)
            collectionView.register(botCellNib, forCellWithReuseIdentifier: collectionViewInfo.botChatCellIdentifier)
            
            let userCellNib = UINib(nibName: "UserChatCollectionViewCell", bundle: nil)
             collectionView.register(userCellNib, forCellWithReuseIdentifier: collectionViewInfo.userChatCellIdentifier)
            
            collectionView.delegate = collectionDelegate
            collectionView.dataSource = collectionDelegate
//            self.collectionView?.isPrefetchingEnabled = false
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myLayout = CustomAlignedCellFlowLayout()//CustomAlignedCellFlowLayout()
        myLayout.flowAlignment = controllerSetting.cellAlignmnet
        myLayout.customFlowDelegate = collectionDelegate

//        UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        myLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
//        myLayout.minimumInteritemSpacing = 20.0;
//        myLayout.minimumLineSpacing = 20.0;
        
        //use class if view is made by code, if nib is used, register by nib.
        //collection view set header view   //PacketDecorationView
        let headerNib = UINib(nibName: "PacketSectionView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionViewInfo.headerReuseIdentifier)
        //set collection layout object..
        collectionView.setCollectionViewLayout(myLayout, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deletePacketAtLast(_ sender: UIBarButtonItem) {
        collectionDelegate.deleteData()
        let delIndex = collectionDelegate.dataStore.dataArray.count
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteSections(IndexSet(integer: delIndex))
        }, completion: nil)
    }
    
    @IBAction func addPacketAtLast(_ sender: UIBarButtonItem) {
        collectionDelegate.addData()
        let insertedIndex = collectionDelegate.dataStore.dataArray.count - 1
        self.collectionView.performBatchUpdates({
            self.collectionView.insertSections(IndexSet(integer: insertedIndex))
        }, completion: nil)
    }
    
}

