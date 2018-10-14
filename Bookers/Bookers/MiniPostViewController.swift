//
//  MiniPostViewController.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/10/02.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit

class MiniPostViewController: UIViewController {
    
    //BookData型の配列,Bookersを宣言
    var Bookers = [BookData]()
    ////BookData型のObjectを宣言
    var Book = BookData()
    var user  = User()
    
    let textview: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return textview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        let view22Width = self.view.frame.size.width / 22
        let view32Height = self.view.frame.size.height / 32
        
        user = NowUser.shared.nowuser
        //シリアライズ 処理（Bookers）
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
