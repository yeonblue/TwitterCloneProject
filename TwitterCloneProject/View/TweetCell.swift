//
//  TweetCellCollectionViewCell.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/10.
//

import UIKit

class TweetCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
