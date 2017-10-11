//
//  PacketDecorationView.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/10/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import UIKit

class PacketDecorationView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let packetDecorationAttribute = layoutAttributes as! PacketDecorationViewLayoutAttributes
        self.backgroundColor = packetDecorationAttribute.color
    }
    
}

class PacketDecorationViewLayoutAttributes : UICollectionViewLayoutAttributes {
    
    var color: UIColor = UIColor.white
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let newAttributes: PacketDecorationViewLayoutAttributes = super.copy(with: zone) as! PacketDecorationViewLayoutAttributes
        newAttributes.color = self.color.copy(with: zone) as! UIColor
        return newAttributes
    }
}
