//
//  ViewController.swift
//  ThetaViewer
//
//  Created by rynagash on 2015/03/06.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import UIKit
import CoreMotion


class ViewController: UIViewController, MyProtocol {
    
    var device = DevicePosture()
    var imageView: UIImageView!
    var navigationBackButton: UIButton!
    
    let imageWidth:Int32 = 2048;
    let imageHeight:Int32 = 1024;
    var yaw:Float = 0.0
    var roll:Float = 0.0
    var pitch:Float = 0.0
    var imageData:NSMutableData?
    var glkView:GlkViewController?
    
    var initDeviceYaw:Float = 999.0
    var initDeviceRoll:Float = 999.0
    var initDevicePitch:Float = 999.0
    
    var yawBuff:[Float] = Array(count: 50, repeatedValue: 0.0)
    var rollBuff:[Float] = Array(count: 50, repeatedValue: 0.0)
    var pitchBuff:[Float] = Array(count: 50, repeatedValue: 0.0)
    
    var buffIndex:Int = 0
    
    /** layout property **/
    
    let WINDOW_MARGIN: CGFloat = 10
    let STATUSBAR_HEIGHT: CGFloat = 20
    let WINDOW_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width
    let WINDOW_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height
    let BUTTON_SIZE: CGSize = CGSizeMake(40, 40)
    let BROWSER_BUTTON_SIZE: CGSize = CGSizeMake(50, 30)
    let INDICATOR_SIZE: CGSize = CGSizeMake(44, 44)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var path:String = NSBundle.mainBundle().pathForResource("theta2", ofType: "jpg")!
        imageData = NSMutableData(contentsOfFile: path)!
        
        getPostureFromData(imageData)
        
        imageView = UIImageView(frame: CGRectMake(0, 0, 600, 600))
        self.view.addSubview(imageView)
        
        startGLK()
        
        // 傾き取得
        self.device.prot = self
        self.device.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGLK() {
        //        glkView = GLView(frame: imageView!.frame)
        glkView = GlkViewController(imageView!.frame, image:imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
        // glkView!.setImage(imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
        
        // glkView!.view.frame = imageView!.frame
        let msg = imageData == nil ? "nil" : "not nil"
        println("startGLK imageData: \(msg)")
        println(String(format:"startGLK: frame %f %f %f %f", imageView!.frame.origin.x, imageView!.frame.origin.y, imageView!.frame.size.width, imageView!.frame.size.height))
        
        // 戻るボタン
        navigationBackButton = UIButton(frame: CGRectMake( WINDOW_MARGIN, STATUSBAR_HEIGHT + WINDOW_MARGIN, BUTTON_SIZE.width, BUTTON_SIZE.height))
        navigationBackButton.backgroundColor = UIColor.whiteColor()
        navigationBackButton.layer.cornerRadius = BUTTON_SIZE.width/2
        navigationBackButton.layer.borderWidth = 0.5
        navigationBackButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        navigationBackButton.addTarget(self, action: "backPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        glkView!.view.addSubview(navigationBackButton)
        
        self.view.addSubview(glkView!.view)
        self.addChildViewController(glkView!)
        self.glkView!.didMoveToParentViewController(self)
    }
    
    // 戻るボタン押下時
    func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func refleshGLK(diffx:Int, diffy:Int) {
        glkView?.setRotation(Int32(diffx), diffy: Int32(diffy))

    }
    
    func detect(att: CMAttitude) {
        var deviceYaw = Float(radiansToDegrees(att.yaw))
        var devicePitch = Float(radiansToDegrees(att.pitch))
        var deviceRoll = Float(radiansToDegrees(att.roll))
        
        // 初期値セット
        if (initDeviceYaw > 900.0 && initDeviceRoll > 900.0 && initDevicePitch > 900.0) {
            initDeviceYaw = deviceYaw
            initDevicePitch = devicePitch
            initDeviceRoll = deviceRoll
            yawBuff = Array(count: 50, repeatedValue: deviceYaw)
            pitchBuff = Array(count: 50, repeatedValue: devicePitch)
            rollBuff = Array(count: 50, repeatedValue: deviceRoll)
        }
        
        yawBuff[buffIndex] = deviceYaw
        pitchBuff[buffIndex] = devicePitch
        rollBuff[buffIndex] = deviceRoll
        buffIndex += 1
        
        if (buffIndex == 50) {
            buffIndex = 0
        }
        
        var diffYaw = deviceYaw - getAverage(yawBuff)
        var diffRoll = deviceRoll - getAverage(rollBuff)
        var diffPitch = devicePitch - getAverage(pitchBuff)
        // TODO: stdout
        // println(String(format:"dev = (%.2f, %.2f, %.2f)", radiansToDegrees(att.yaw), radiansToDegrees(att.roll), radiansToDegrees(att.pitch)))
        // println(String(format:"diff = (%.2f, %.2f, %.2f)", radiansToDegrees(att.yaw), radiansToDegrees(att.roll), radiansToDegrees(att.pitch)))
        // println(String(format:"pic = (%.2f, %.2f, %.2f)", yaw, roll, pitch))
        
        // TOOD: ここいらん　洗い出して削除
        if (fabsf(diffYaw) > 1 && true) {
            if (diffYaw > 0) {
                yaw -= sqrtf(diffYaw)
            } else {
                yaw += sqrtf(-diffYaw)
            }
        }
        
        if (fabsf(diffRoll) > 1 && true) {
            if (diffRoll > 0) {
                roll -= sqrtf(diffRoll)
            } else {
                roll += sqrtf(-diffRoll)
            }
        }
        if (fabsf(diffPitch) > 1 && true) {
            if (diffPitch > 0) {
                pitch -= sqrtf(diffPitch)
            } else {
                pitch += sqrtf(-diffPitch)
            }
        }
        
        refleshGLK(Int(-1 * diffRoll * 1.3), diffy: Int(diffPitch))
    }
    
}


