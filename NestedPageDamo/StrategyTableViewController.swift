//
//  StrategyTableViewController.swift
//  NestedPageDamo
//
//  Created by fashion on 2018/3/1.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class StrategyTableViewController: UITableViewController {

    /*
     Self-Sizing在iOS11下是默认开启的，Headers, footers, and cells都默认开启Self-Sizing，所有estimated 高度默认值从iOS11之前的 0 改变为UITableViewAutomaticDimension。
     
     如果目前项目中没有使用estimateRowHeight属性，在iOS11的环境下就要注意了，因为开启Self-Sizing之后，tableView是使用estimateRowHeight属性的，这样就会造成contentSize和contentOffset值的变化，如果是有动画是观察这两个属性的变化进行的，就会造成动画的异常，因为在估算行高机制下，contentSize的值是一点点地变化更新的，所有cell显示完后才是最终的contentSize值。因为不会缓存正确的行高，tableView reloadData的时候，会重新计算contentSize，就有可能会引起contentOffset的变化。
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: headerViewH))
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: resuseId)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: resuseId)
            cell?.contentView.backgroundColor = UIColor.white
        }
        // Configure the cell...
        cell!.textLabel?.text = "测试\(indexPath.row)"
        
        return cell!
    }
}

