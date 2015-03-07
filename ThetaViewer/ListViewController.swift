//
//  ListViewController.swift
//  ThetaViewer
//
//  Created by 大久保 和訓 on 2015/03/07.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyProtocol {
    
    // UI
    var tableView: UITableView!
    var infoButton: UIButton!
    var modalView: ModalView!
    var unvisibleLayer: UIButton!
    
    var device = DevicePosture()
    
    let WINDOW_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height
    let WINDOW_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width
    
    let imageWidth:Int32 = 2048;
    let imageHeight:Int32 = 1024;
    var yaw:Float = 0.0
    var roll:Float = 0.0
    var pitch:Float = 0.0
    var glkView:GlkViewController?
    let titles = ["ここにタイトル", "title here!", "うぇーい！", "4", "5", "6"]
    let names = ["_akny", "_akny", "_akny", "_akny", "_akny"]
    let dates = ["2015/3/8 14:08", "2015/3/7 20:19", "2015/3/7 12:10", "2015/3/7 12:10", "2015/3/7 12:10"]
    let places = ["由比ヶ浜海岸", "東京ミッドタウン", "浅草大久保氏邸", "浅草大久保氏邸", "浅草大久保氏邸"]
    let comments = ["春の由比ヶ浜海岸。浜大根の花が満開でとてもきれいでした！！", "ほげ", "ふが", "春の由比ヶ浜海岸。浜大根の花が満開でとてもきれいでした！！", "春の由比ヶ浜海岸。浜大根の花が満開でとてもきれいでした！！"]
    
    var initDeviceYaw:Float = 999.0
    var initDeviceRoll:Float = 999.0
    var initDevicePitch:Float = 999.0
    
    var yawBuff:[Float] = Array(count: 50, repeatedValue: 0.0)
    var rollBuff:[Float] = Array(count: 50, repeatedValue: 0.0)
    var pitchBuff:[Float] = Array(count: 50, repeatedValue: 0.0)
    
    var buffIndex:Int = 0
    
    var openedRow = 0
    
    
    /** layout property **/
    let WINDOW_MARGIN: CGFloat = 20
    let MODAL_HEIGHT: CGFloat = 110
    let INFO_BUTTON_SIZE: CGSize = CGSizeMake(37, 37)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationbarを非表示
        self.navigationController?.navigationBarHidden = true
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: WINDOW_HEIGHT, height: WINDOW_HEIGHT))
        
        // TableViewのページング処理
        tableView.pagingEnabled = true
        
        // TableViewの線を消す
        tableView.separatorColor = UIColor.clearColor()
        
        // Cell名の登録をおこなう.
        tableView.registerClass(ListViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定をする.
        tableView.dataSource = self
        
        // Delegateを設定する.
        tableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(tableView)
        
        // 傾き取得
        self.device.prot = self
        self.device.start()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return WINDOW_HEIGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as ListViewCell
        
        if(glkView != nil){
            glkView!.glRenderView.deleteTexture()
            glkView = nil
        }
        
        let view = UIImageView(frame: CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
        cell.setThumbnailImage(startGLK(view, row:indexPath.row))
        //cell.titleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    // cellを選択でモーダルを閉じる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func startGLK(view:UIImageView?, row:Int) -> UIView {
        openedRow = row
        let path:String = NSBundle.mainBundle().pathForResource("theta" + String(row+1), ofType: "jpg")!
        println("Read file =  \(path)")

        let imageData = NSMutableData(contentsOfFile: path)!
        getPostureFromData(imageData)
        
        glkView = GlkViewController(view!.frame, image:imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
        glkView!.view.frame = view!.frame
        //glkView!.view.userInteractionEnabled = false
        
        // infoボタン
        var imageNormal = UIImage(named: "ic_info")
        var imageTapped = UIImage(named: "ic_info_tapped")
        infoButton = UIButton(frame: CGRectMake(
            WINDOW_WIDTH - WINDOW_MARGIN - INFO_BUTTON_SIZE.width,
            WINDOW_HEIGHT - WINDOW_MARGIN - INFO_BUTTON_SIZE.height,
            INFO_BUTTON_SIZE.width, INFO_BUTTON_SIZE.height))
        infoButton.addTarget(self, action: "infoTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        infoButton.setImage(imageNormal, forState: .Normal)
        infoButton.setImage(imageTapped, forState: .Highlighted)
        glkView!.view.addSubview(infoButton)

        return glkView!.view
    }
    
    // infoボタン押下時
    func infoTouchUp(sender: AnyObject) {
        unvisibleLayer = UIButton(frame: CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
        unvisibleLayer.alpha = 1.0
        unvisibleLayer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        unvisibleLayer.addTarget(self, action: "closeModal:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(unvisibleLayer)
        openModal(names[openedRow], place: places[openedRow], date: dates[openedRow], comment: comments[openedRow])

    }
    
    func openModal(user:String, place:String, date:String, comment:String) {
        modalView = ModalView(frame: CGRectMake(
            0, WINDOW_HEIGHT, WINDOW_WIDTH, MODAL_HEIGHT))
        modalView.setUserName(user)
        modalView.setDate(date)
        modalView.setPlace(place)
        modalView.setComment(comment)
        self.view.addSubview(modalView)
        modalView.alpha = 1.0
        infoButton.alpha = 0.0
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.modalView.center = CGPoint(x: self.WINDOW_WIDTH/2, y: self.WINDOW_HEIGHT - (self.MODAL_HEIGHT/2));
            }, completion: {(Bool) -> Void in
        })
    }
    
    func closeModal(sender: AnyObject) {
        infoButton.alpha = 1.0
        unvisibleLayer.alpha = 0.0
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.modalView.center = CGPoint(x: self.WINDOW_WIDTH/2, y: self.WINDOW_HEIGHT + (self.MODAL_HEIGHT/2));
            }, completion: {(Bool) -> Void in
                self.modalView.alpha = 0.0
        })
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
        
        refleshGLK(Int(-1 * diffRoll * 1.3), diffy: Int(diffPitch))
    }

    
}
