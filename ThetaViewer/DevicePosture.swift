//
//  DevicePosture.swift
//  ThetaViewer
//
//  Created by rynagash on 2015/03/07.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import Foundation
import CoreMotion

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
        // println("thresold = \(self.thresold)")
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


