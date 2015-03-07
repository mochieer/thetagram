//
//  ViewController.swift
//  ThetaViewer
//
//  Created by rynagash on 2015/03/06.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import UIKit
import CoreMotion


func rad2deg(rad:Float) -> Float {
    return Float(180.0 * Double(rad) / M_PI)
}

func format(deg:Float) -> Float {
    let unit:Float = 180
    println(Int(deg / unit))
    var ret:Float = deg - unit * Float(Int(deg/unit))
    return ret
}

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
        pitch = isnan(exif.pitch) ? 0.0 : format(exif.pitch)
        
        println(String(format: "%f, %f, %f", yaw, roll, pitch))
        
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
        glkView = GlkViewController(imageView!.frame, image:imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
        glkView!.setImage(imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
        
        glkView!.view.frame = imageView!.frame
        println("startGLK imageData: \(NSString(data: imageData!, encoding:NSUTF8StringEncoding))")
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
    
    func refleshGLK() {
        if (yaw < 0.0) {
            yaw = 0.0
        } else if (yaw > 360.0) {
            yaw = 360.0
        }
        if (roll < 0.0) {
            roll = 360.0 - roll
        } else if (roll > 360) {
            roll -= 360.0
        }
        if (pitch < -90.0) {
            pitch = -90.0
        } else if (pitch > 90.0) {
            pitch = 90.0
        }
        glkView?.setPosture(yaw, roll: roll, pitch: pitch)
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
        println(String(format:"dev = (%.2f, %.2f, %.2f)", radiansToDegrees(att.yaw), radiansToDegrees(att.roll), radiansToDegrees(att.pitch)))
        println(String(format:"diff = (%.2f, %.2f, %.2f)", radiansToDegrees(att.yaw), radiansToDegrees(att.roll), radiansToDegrees(att.pitch)))
        println(String(format:"pic = (%.2f, %.2f, %.2f)", yaw, roll, pitch))

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
        
        refleshGLK()
    }
 
}













protocol MyProtocol {
    func detect(CMAttitude)
}

class DevicePosture {
    var prot: MyProtocol?
    
    let motionManager: CMMotionManager
    var patti: CMAttitude?
    
    var thresold = degreesToRadians(0.01) ^ 2 // 0.5[deg]以上の変化
    var minMax = [0.0, 0.0]

    init() {
        self.motionManager = CMMotionManager()
        println("thresold = \(self.thresold)")
    }
    func start() {
        // Initialize MotionManager
        self.motionManager.deviceMotionUpdateInterval = 0.05 // 20Hz
        
        // Start motion data acquisition
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler : {
            deviceManager, error in
            var accel : CMAcceleration = deviceManager.userAcceleration
            var gyro : CMRotationRate = deviceManager.rotationRate
            var attitude : CMAttitude = deviceManager.attitude
            var quaternion : CMQuaternion = attitude.quaternion
            
            if (self.patti != nil) {
                var diff = [self.patti!.yaw - attitude.yaw, self.patti!.roll - attitude.roll, self.patti!.pitch - attitude.pitch]
                var length:Double? = diff * diff
                if (length! > self.thresold){
                    self.prot!.detect(attitude)
                }
            }
            self.patti = attitude
        })
    }
    
    func stop() {
        if (self.motionManager.deviceMotionActive) {
            self.motionManager.stopMagnetometerUpdates()
        }
    }
}





// 以下関数

// Degrees to Radian
func degreesToRadians(degrees:Double) -> Double {
    return degrees / 180.0 * M_PI
}

// Radians to Degrees
func radiansToDegrees(radians:Double) -> Double {
    return radians  * (180.0 / M_PI)
}

// power
func ^ (left:Double, right:Double) -> Double {
    return pow(left, right)
}

// Inner product
func * (left:Array<Double>, right:Array<Double>) -> Double? {
    if (left.count != right.count) {
        return nil;
    }
    var ret = 0.0
    for (var i = 0; i < left.count; i++) {
        ret += left[i] * right[i]
    }
    return ret
}

func getAverage(array:Array<Float>) -> Float {
    if (array.count == 0) {
        return 0.0
    }
    
    var average:Float = 0.0
    for value in array {
        average += value
    }
    return (average / Float(array.count))
}

