//
//  ReRegisterViewController.swift
//  Matching
//
//  Created by 杉山佳史 on 2018/10/17.
//  Copyright © 2018 SUGIYOSI. All rights reserved.
//

import UIKit

class ReRegisterViewController: UIViewController {
    
    let AgeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let SexLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let ColleageLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let ProfileLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
