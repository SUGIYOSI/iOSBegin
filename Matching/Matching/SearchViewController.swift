//
//  SearchViewController.swift
//  Matching
//
//  Created by 杉山佳史 on 2018/10/17.
//  Copyright © 2018 SUGIYOSI. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let SexLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let AgeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let LivesLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let ColleageLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let SearchButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
