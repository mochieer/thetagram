//
//  ListViewCell.swift
//  ThetaViewer
//
//  Created by 大久保 和訓 on 2015/03/07.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    
    var thumbnailImageView: UIImageView!
    var titleLabel: UILabel!
    
    let WINDOW_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width
    let WINDOW_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height
    
    let imageWidth:Int32 = 2048;
    let imageHeight:Int32 = 1024;
    var yaw:Float = 0.0
    var roll:Float = 0.0
    var pitch:Float = 0.0
    var imageData:NSMutableData?
    var glkView:GlkViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        thumbnailImageView = UIImageView(frame: CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
        thumbnailImageView.backgroundColor = UIColor.orangeColor()
        thumbnailImageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(thumbnailImageView)
        
        titleLabel = UILabel(frame: CGRectMake(0, WINDOW_HEIGHT/4, WINDOW_WIDTH, 40))
        titleLabel.font = UIFont(name: "HiraKakuProN-W3", size: 40)
        titleLabel.textAlignment = .Right
        thumbnailImageView.addSubview(titleLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func startGLK() {
//        glkView = GlkViewController(imageView!.frame, image:imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
//        // glkView!.setImage(imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
//        
//        glkView!.view.frame = imageView!.frame
//        let msg = imageData == nil ? "nil" : "not nil"
//        println("startGLK imageData: \(msg)")
//        println(String(format:"startGLK: frame %f %f %f %f", imageView!.frame.origin.x, imageView!.frame.origin.y, imageView!.frame.size.width, imageView!.frame.size.height))
//        
//        // 戻るボタン
//        //        navigationBackButton = UIButton(frame: CGRectMake( WINDOW_MARGIN, STATUSBAR_HEIGHT + WINDOW_MARGIN, BUTTON_SIZE.width, BUTTON_SIZE.height))
//        //        navigationBackButton.backgroundColor = UIColor.whiteColor()
//        //        navigationBackButton.layer.cornerRadius = BUTTON_SIZE.width/2
//        //        navigationBackButton.layer.borderWidth = 0.5
//        //        navigationBackButton.layer.borderColor = UIColor.lightGrayColor().CGColor
//        //        navigationBackButton.addTarget(self, action: "backPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        glkView!.view.addSubview(navigationBackButton)
//        
//        
//        self.view.addSubview(glkView!.view)
//        
//        self.addChildViewController(glkView!)
//        self.glkView!.didMoveToParentViewController(self)
//    }
}
