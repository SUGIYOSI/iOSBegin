//
//  RegisterViewController.swift
//  Matching
//
//  Created by 杉山佳史 on 2018/10/17.
//  Copyright © 2018 SUGIYOSI. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let RoginLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let UserNameField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    let EmailField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    let PasswordField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    let UserNameImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let EmailImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let PassWordImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
