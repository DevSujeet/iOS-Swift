//
//  PacketSectionView.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/10/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import UIKit

class PacketSectionView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!{
        didSet {
                sectionTitleLabel.text = "section header"
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
