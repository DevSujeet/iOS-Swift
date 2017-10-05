//
//  WidgetCollectionViewCell.swift
//  collectionViewTest
//
//  Created by Sujeet.Kumar on 10/4/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import UIKit

class WidgetCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.red
    }

//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        
//        let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
//        
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        
//        let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
//        attr.frame.size.height = desiredHeight
//        self.frame = attr.frame  // Do NOT forget to set the frame or the layout won't get it !!!
//        
//        return attr
//    }
}
