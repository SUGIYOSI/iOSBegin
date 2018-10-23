//
//  HomeViewController.swift
//  Matching
//
//  Created by 杉山佳史 on 2018/10/17.
//  Copyright © 2018 SUGIYOSI. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
       // LoginCheck()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image:UIImage(named:"setting"))
       // let button = UIImageView(image:UIImage(named:"setting"))
       // self.navigationItem.setRightBarButtonItems(button, animated: true)
        let oioioio: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"event"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = oioioio
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func LoginCheck(){
        if NowUser.shared.nowuser.UserName == nil{
            let nc = UINavigationController(rootViewController: LoginViewController())
            self.present(nc, animated: true, completion: nil)
        }
    }
}


