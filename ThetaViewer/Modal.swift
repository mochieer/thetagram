//
//  Modal.swift
//  ThetaViewer
//
//  Created by mochieer on 2015/03/08.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import Foundation
import UIKit

class ModalView :UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.88)
        var mappinView = UIImageView(frame: CGRectMake(78, 43, 12, 15))
        var userImageView = UIImageView(frame: CGRectMake(10, 10, 58, 58))
        userImageView.image = UIImage(named: "ic_user_thumbnail")
        mappinView.image = UIImage(named: "ic_mappin")
        
        self.addSubview(userImageView)
        self.addSubview(mappinView)
    }
    
    func setUserName(name: String) {
        let userNameView : UILabel = UILabel(frame: CGRectMake(78, 8, 300, 36))
        userNameView.text = name
        userNameView.textColor = UIColor(red: 0.403, green: 0.403, blue: 0.403, alpha: 1.0)
        userNameView.font = UIFont(name: "HiraKakuProN-W6", size: 18)
        self.addSubview(userNameView)
    }
    
    func setDate(date: String) {
        var dateView = UILabel(frame: CGRectMake(0, 14, UIScreen.mainScreen().bounds.width - 10, 28))
        dateView.text = date
        dateView.font = UIFont(name: "HiraKakuProN-W3", size: 14)
        dateView.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        dateView.textAlignment = .Right
        self.addSubview(dateView)
    }
    
    func setPlace(place: String) {
        var placeView = UILabel(frame: CGRectMake(95, 36, 300, 28))
        placeView.text = place
        placeView.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        placeView.font = UIFont(name: "HiraKakuProN-W6", size: 14)
        self.addSubview(placeView)
    }
    
    func setComment(comment: String) {
        var commentView = UILabel(frame: CGRectMake(78, 67, UIScreen.mainScreen().bounds.width - 88, 20))
        commentView.text = comment
        commentView.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        commentView.font = UIFont(name: "HiraKakuProN-W3", size: 14)
        commentView.numberOfLines = 2
        commentView.sizeToFit()
        self.addSubview(commentView)
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}