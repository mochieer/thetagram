//
//  ListViewCell.swift
//  ThetaViewer
//
//  Created by 大久保 和訓 on 2015/03/07.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    
    var thumbnailImageView: UIView!
    var titleLabel: UILabel!
    
    let WINDOW_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width
    let WINDOW_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        thumbnailImageView = UIImageView(frame: CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
        contentView.addSubview(thumbnailImageView)
        
        titleLabel = UILabel(frame: CGRectMake(0, WINDOW_HEIGHT/4, WINDOW_WIDTH, 40))
        titleLabel.font = UIFont(name: "HiraKakuProN-W3", size: 40)
        titleLabel.textAlignment = .Right
        self.addSubview(titleLabel)
    }
    
    func setThumbnailImage(view: UIView){
//        thumbnailImageView = UIImageView(frame: CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
//        thumbnailImageView.backgroundColor = UIColor.orangeColor()
//        thumbnailImageView.contentMode = UIViewContentMode.ScaleAspectFit
        thumbnailImageView = view
        contentView.addSubview(thumbnailImageView)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
