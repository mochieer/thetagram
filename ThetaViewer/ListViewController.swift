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
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return WINDOW_HEIGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as ListViewCell
        
        cell.titleLabel.text = "ここにタイトル"
        
        return cell
    }
    
    // cellを選択で詳細へ遷移
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc: ViewController = ViewController()
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}
