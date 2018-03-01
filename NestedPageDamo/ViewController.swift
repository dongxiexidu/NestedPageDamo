//
//  ViewController.swift
//  NestedPageDamo
//
//  Created by fashion on 2018/3/1.
//  Copyright © 2018年 shangZhu. All rights reserved.
//  原文 :http://hasjoh.cc/2017/12/28/iOS-多重嵌套式页面/#more

import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let isIphoneX : Bool = kScreenH == 812.0 ? true : false
let kNavBarTotalH :CGFloat = isIphoneX ? 88 : 64

let scrollViewH = kScreenH-kNavBarTotalH
let headerViewH :CGFloat = 200

class ViewController: UIViewController {
    
    let introduceTVC = IntroduceTableViewController()
    let strategyTVC = StrategyTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        view.addSubview(headerView)
        
        setupChildViewController(controller: introduceTVC, x: 0)
        setupChildViewController(controller: strategyTVC, x: kScreenW)
        
    }
    
    func setupChildViewController(controller: UITableViewController,x: CGFloat) {
        controller.view.frame = CGRect.init(x: x, y: 0, width: kScreenW, height: scrollViewH)
        addChildViewController(controller)
        scrollView.addSubview(controller.view)
        controller.tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    // MARK:KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
          
            let headerViewScrollStopY = headerViewH - 70.0
            let tableView = object as! UITableView
            let contentOffsetY = tableView.contentOffset.y
            if contentOffsetY < headerViewScrollStopY {
                self.headerView.y = -tableView.contentOffset.y+kNavBarTotalH
                print(self.headerView.y)
                // 同步tableView的contentOffset
                for vc in self.childViewControllers {
                    if (vc as! UITableViewController).tableView.contentOffset.y != tableView.contentOffset.y {
                        (vc as! UITableViewController).tableView.contentOffset = tableView.contentOffset
                    }
                }
            }else{// 头部视图固定位置
                
                self.headerView.y = -headerViewScrollStopY+kNavBarTotalH
                // 解决高速滑动下tableView偏移量错误的问题
                if (self.headerView.segmentedControl.selectedSegmentIndex == 0) {
                    let vc = self.childViewControllers[1] as! UITableViewController
                    if vc.tableView.contentOffset.y < headerViewScrollStopY {
                        var contentOffset = vc.tableView.contentOffset
                        contentOffset.y = headerViewScrollStopY
                        vc.tableView.contentOffset = contentOffset
                    }
                } else {
                    let vc = self.childViewControllers[1] as! UITableViewController
                    if vc.tableView.contentOffset.y < headerViewScrollStopY {
                        var contentOffset = vc.tableView.contentOffset
                        contentOffset.y = headerViewScrollStopY
                        vc.tableView.contentOffset = contentOffset
                    }
                }
                
            }
            
        }
    }

    
    @objc func segmentedControlValueChange(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            scrollView.contentOffset = CGPoint.zero
        }else{
            scrollView.contentOffset = CGPoint.init(x: kScreenW, y: 0)
        }
    }
    
    deinit {
        introduceTVC.tableView.removeObserver(self, forKeyPath: "contentOffset")
        strategyTVC.tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    lazy var headerView: HeaderView = {
        let head = HeaderView.loadFromNib()
        head.frame = CGRect.init(x: 0, y: kNavBarTotalH, width: kScreenW, height: headerViewH)
        head.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChange(segment:)), for: .valueChanged)
        return head
    }()
    
    lazy var scrollView: UIScrollView = {
        
        let scrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: kNavBarTotalH, width: kScreenW, height: scrollViewH))
        
        scrollV.contentSize = CGSize.init(width: kScreenW*2, height: scrollViewH)
        scrollV.bounces = false
        scrollV.showsVerticalScrollIndicator = false
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.isPagingEnabled = true
        scrollV.delegate = self
        return scrollV
    }()
    

}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            // 滑动到游戏介绍页
            if (scrollView.contentOffset.x == 0) {
                if (self.headerView.segmentedControl.selectedSegmentIndex != 0) {
                    self.headerView.segmentedControl.selectedSegmentIndex = 0
                }
                // 滑动到攻略页
            } else if (scrollView.contentOffset.x == kScreenW) {
                if (self.headerView.segmentedControl.selectedSegmentIndex != 1) {
                    self.headerView.segmentedControl.selectedSegmentIndex = 1
                }
            }
        }
    }
}

