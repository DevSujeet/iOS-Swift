//
//  ViewController.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/5/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let collectionDelegate = CollectionViewDelegate()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(WidgetCollectionViewCell.self, forCellWithReuseIdentifier: "WidgetCollectionViewCell")
            collectionView.delegate = collectionDelegate
            collectionView.dataSource = collectionDelegate
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myLayout = TopAlignedCollectionViewFlowLayout()//CustomAlignedCellFlowLayout()
//        myLayout.alignment = .top

//        myLayout.sectionInset = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
//        myLayout.minimumInteritemSpacing = 20.0;
//        myLayout.minimumLineSpacing = 20.0;
        collectionView.setCollectionViewLayout(myLayout, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

