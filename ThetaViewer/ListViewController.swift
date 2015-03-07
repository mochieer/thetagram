//
//  ListViewController.swift
//  ThetaViewer
//
//  Created by 大久保 和訓 on 2015/03/07.
//  Copyright (c) 2015年 rynagash. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI
    var tableView: UITableView!
    
    let WINDOW_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height
    let WINDOW_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width
    
    let imageWidth:Int32 = 2048;
    let imageHeight:Int32 = 1024;
    var yaw:Float = 0.0
    var roll:Float = 0.0
    var pitch:Float = 0.0
    // var imageData:NSMutableData?
    var glkView:GlkViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationbarを非表示
        self.navigationController?.navigationBarHidden = true
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: WINDOW_HEIGHT, height: WINDOW_HEIGHT))
        
        // TableViewのページング処理
        tableView.pagingEnabled = true
        
        // Cell名の登録をおこなう.
        tableView.registerClass(ListViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定をする.
        tableView.dataSource = self
        
        // Delegateを設定する.
        tableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(tableView)
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return WINDOW_HEIGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as ListViewCell
        
        let view = UIImageView(frame: CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
        cell.setThumbnailImage(startGLK(view, row:indexPath.row))
        cell.titleLabel.text = "ここにタイトル"
        
        return cell
    }
    
    // cellを選択で詳細へ遷移
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc: ViewController = ViewController()
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func startGLK(view:UIImageView?, row:Int) -> UIView {
        let path:String = NSBundle.mainBundle().pathForResource("theta" + String(row+1), ofType: "jpg")!
        println("Read file =  \(path)")

        let imageData = NSMutableData(contentsOfFile: path)!
        getPostureFromData(imageData)
        
        glkView = GlkViewController(view!.frame, image:imageData, width:imageWidth, height:imageHeight, yaw:yaw, roll:roll, pitch:pitch)
        glkView!.view.frame = view!.frame
        glkView!.view.userInteractionEnabled = false
        return glkView!.view
        //        self.view.addSubview(glkView!.view)
        //
        //        self.addChildViewController(glkView!)
        //        self.glkView!.didMoveToParentViewController(self)
    }
    
    
}
