//
//  TabBarController.swift
//  Matching
//
//  Created by 杉山佳史 on 2018/10/17.
//  Copyright © 2018 SUGIYOSI. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController{
    
    enum ViewControllers {
        case home
        case event
        case bothMatch
        case setting
    }
    

    var homeview: HomeViewController!
    var eventview: EventViewController!
    var bothMatch: BothMatchViewController!
    var setting: SettingViewController!
    let vcArray: [ViewControllers] = [.home,.event,.bothMatch,.setting]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myTabs: [UIViewController] = []
        
        for (i, vc) in vcArray.enumerated() {
            var tabVC: UIViewController!
            switch vc {
            case .home:
                tabVC = HomeViewController()
                tabVC.tabBarItem.image = UIImage(named: "search")?.resize(size: CGSize(width: 30, height: 30))
                tabVC.tabBarItem.tag = i
                tabVC.tabBarItem.title = "Search"
            case .event:
                tabVC = EventViewController()
                tabVC.tabBarItem.image = UIImage(named: "event")?.resize(size: CGSize(width: 30, height: 30))
                tabVC.tabBarItem.tag = i
                tabVC.tabBarItem.title = "Event"
            case .bothMatch:
                tabVC = BothMatchViewController()
                tabVC.tabBarItem.image = UIImage(named: "bothmatch")?.resize(size: CGSize(width: 40, height: 40))
                tabVC.tabBarItem.tag = i
                tabVC.tabBarItem.title = "Both"
            case .setting:
                tabVC = SettingViewController()
                tabVC.tabBarItem.image = UIImage(named: "setting")?.resize(size: CGSize(width: 30, height: 30))
                tabVC.tabBarItem.tag = i
                tabVC.tabBarItem.title = "Setting"
            }
            let nc = UINavigationController(rootViewController: tabVC)
            myTabs.append(nc)
        }
        
        self.setViewControllers(myTabs, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        // 画質を落とさないように以下を修正
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

