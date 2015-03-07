//
//  common.swift
//  ThetaViewer
//
//  Created by rynagash on 2015/03/07.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import Foundation

func format(deg:Float) -> Float {
    let unit:Float = 360
    // println(Int(deg / unit))
    var ret:Float = deg - unit * Float(Int(deg/unit))
    
    while(ret > 0.0){
        ret -= 90.0
    }
    
    return ret
}

func getPostureFromData(img:NSData?) -> Dictionary<String,Float> {
    // 画像メタ情報のパース
    var exif:RicohEXIF = RicohEXIF(NSData: img!)
    
    // 方位角
    //     0 - 360
    let yaw = isnan(exif.yaw) ? 0.0 : exif.yaw
    
    // 水平角
    //     0 - 360
    let roll = isnan(exif.roll) ? 0.0 : exif.roll
    
    // 仰角
    //     -90 - 90
    let pitch = isnan(exif.pitch) ? 0.0 : format(exif.pitch)
    
    println(String(format: "Initial = (%f, %f, %f)", yaw, roll, pitch))
    
    return ["yaw":yaw, "roll":roll, "pitch":pitch]
}



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

