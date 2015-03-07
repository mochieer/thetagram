//
//  ViewController.swift
//  ThetaViewer
//
//  Created by rynagash on 2015/03/06.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    
    let imageWidth:Int32 = 2048;
    let imageHeight:Int32 = 1024;
    var yaw:Float = 0.0
    var roll:Float = 0.0
    var pitch:Float = 0.0
    var imageData:NSMutableData?
    var glkView:GlkViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var path:String = NSBundle.mainBundle().pathForResource("theta1", ofType: "jpg")!
        imageData = NSMutableData(contentsOfFile: path)!
        
       
        // 画像メタ情報のパース
        var exif:RicohEXIF = RicohEXIF(NSData: imageData);
        
        // 方位角
        //     0 - 360
        yaw = isnan(exif.yaw) ? 0.0 : exif.yaw;
        
        // 水平角
        //     0 - 360
        roll = isnan(exif.roll) ? 0.0 : exif.roll;
        
        // 仰角
        //     -90 - 90
        pitch = isnan(exif.pitch) ? 0.0 :  exif.pitch
        
        imageView = UIImageView(frame: CGRectMake(0, 0, 600, 600))
        
        self.view.addSubview(imageView)
       
        startGLK()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startGLK() {
        glkView = GlkViewController(imageView!.frame, image:imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
        
        glkView!.view.frame = imageView!.frame
        println("startGLK imageData: \(NSString(data: imageData!, encoding:NSUTF8StringEncoding))")
        println(String(format:"startGLK: frame %f %f %f %f", imageView!.frame.origin.x, imageView!.frame.origin.y, imageView!.frame.size.width, imageView!.frame.size.height))
    
        self.view.addSubview(glkView!.view)
    
        self.addChildViewController(glkView!)
        glkView!.didMoveToParentViewController(self)
        
    }
}

