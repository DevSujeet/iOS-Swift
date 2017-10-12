//
//  BotChatCollectionViewCell.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/5/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import UIKit

class BotChatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var chatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.red
    }

}
