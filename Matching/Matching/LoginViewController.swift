//
//  LoginViewController.swift
//  Matching
//
//  Created by 杉山佳史 on 2018/10/17.
//  Copyright © 2018 SUGIYOSI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var user = User()
    
    let RoginLabel: UILabel = {
        let label = UILabel()
        label.text = "ログイン"
        return label
    }()
    
    let EmailField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        return textField
    }()
    
    let PasswordField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        return textField
    }()
    
    let LoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("ログイン", for: UIControlState.normal)
        return button
    }()
    
    let RegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("登録する", for: UIControlState.normal)
        return button
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
        
        let view8Width = self.view.frame.size.width / 8
        let view7Height = self.view.frame.size.height / 7
        
        view.addSubview(RoginLabel)
        view.addSubview(EmailField)
        view.addSubview(PasswordField)
        view.addSubview(LoginButton)
        view.addSubview(RegisterButton)
        view.addSubview(EmailImage)
        view.addSubview(PassWordImage)
    
        RoginLabel.translatesAutoresizingMaskIntoConstraints = false
        RoginLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: view7Height * 0.5).isActive = true
        RoginLabel.widthAnchor.constraint(equalToConstant: view8Width * 5).isActive = true
        RoginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RoginLabel.heightAnchor.constraint(equalToConstant: view7Height).isActive = true

        EmailField.translatesAutoresizingMaskIntoConstraints = false
        EmailField.topAnchor.constraint(equalTo: RoginLabel.bottomAnchor,constant: view7Height * 0.5).isActive = true
        EmailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        EmailField.widthAnchor.constraint(equalToConstant: view8Width * 5).isActive = true
        EmailField.heightAnchor.constraint(equalToConstant: view7Height).isActive = true
        
        LoginButton.translatesAutoresizingMaskIntoConstraints = false
        LoginButton.topAnchor.constraint(equalTo: EmailField.bottomAnchor, constant: view7Height * 0.5).isActive = true
        LoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginButton.widthAnchor.constraint(equalToConstant: view8Width * 4).isActive = true
        LoginButton.heightAnchor.constraint(equalToConstant: view7Height).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
