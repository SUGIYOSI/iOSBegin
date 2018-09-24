//
//  LoginViewController.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/09/19.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController , UITextFieldDelegate{
    
    var users = [User()]
    var user  = User()
    

    
    let UserID: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return textfield
    }()
    
    let Password: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return textfield
    }()
    
    let LoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let UserIDLabel: UILabel = {
        let label = UILabel()
        label.text = "UserID"
        return label
    }()
    
    
    let PasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        return label
    }()
    
    let ORLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let LoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.setTitle("Login", for: UIControlState.normal)
        button.addTarget(self, action: #selector(LoginEvent(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let RegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.setTitle("Register", for: UIControlState.normal)
        button.addTarget(self, action: #selector(RegisterEvent(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        let view22Width = self.view.frame.size.width / 22
        let view32Height = self.view.frame.size.height / 32
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let userDefaults = UserDefaults.standard
        if let storedusers = userDefaults.object(forKey: "users") as? Data {
            if let unarchiveusers = NSKeyedUnarchiver.unarchiveObject(with: storedusers) as? [User] {
                users.append(contentsOf: unarchiveusers)
            }
        }
        
        
        UserID.delegate = self
        Password.delegate = self
        UserID.placeholder = "UserIDを入力"
        Password.placeholder = "Passwordを入力"
        
        UserID.clearButtonMode = .always
        Password.clearButtonMode = .always
        

        view.addSubview(UserID)
        view.addSubview(UserIDLabel)
        view.addSubview(LoginLabel)
        view.addSubview(Password)
        view.addSubview(PasswordLabel)
        view.addSubview(ORLabel)
        view.addSubview(RegisterButton)
        view.addSubview(LoginButton)
        
        //AutoLayout
        LoginLabel.translatesAutoresizingMaskIntoConstraints = false
        LoginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view32Height * 5).isActive = true
        LoginLabel.widthAnchor.constraint(equalToConstant: view22Width * 5).isActive = true
        LoginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginLabel.heightAnchor.constraint(equalToConstant: view32Height * 3).isActive = true
        
        UserIDLabel.translatesAutoresizingMaskIntoConstraints = false
        UserIDLabel.topAnchor.constraint(equalTo: LoginLabel.bottomAnchor, constant: view32Height * 1.5).isActive = true
        UserIDLabel.leadingAnchor.constraint(equalTo: UserID.leadingAnchor).isActive = true
        UserIDLabel.widthAnchor.constraint(equalToConstant: view22Width * 6).isActive = true
        UserIDLabel.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        UserID.translatesAutoresizingMaskIntoConstraints = false
        UserID.topAnchor.constraint(equalTo: UserIDLabel.bottomAnchor, constant: view32Height * 0.5).isActive = true
        UserID.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        UserID.widthAnchor.constraint(equalToConstant: view22Width * 13).isActive = true
        UserID.heightAnchor.constraint(equalTo: UserIDLabel.heightAnchor).isActive = true
        
        PasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        PasswordLabel.topAnchor.constraint(equalTo: UserID.bottomAnchor, constant: view32Height * 1.0).isActive = true
        PasswordLabel.leadingAnchor.constraint(equalTo: Password.leadingAnchor).isActive = true
        PasswordLabel.widthAnchor.constraint(equalToConstant: view22Width * 6).isActive = true
        PasswordLabel.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        Password.translatesAutoresizingMaskIntoConstraints = false
        Password.topAnchor.constraint(equalTo: PasswordLabel.bottomAnchor, constant: view32Height * 0.5).isActive = true
        Password.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Password.widthAnchor.constraint(equalToConstant: view22Width * 13).isActive = true
        Password.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        LoginButton.translatesAutoresizingMaskIntoConstraints = false
        LoginButton.topAnchor.constraint(equalTo: Password.bottomAnchor, constant: view32Height * 2).isActive = true
        LoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginButton.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        LoginButton.heightAnchor.constraint(equalToConstant: view32Height).isActive = true
        
        ORLabel.translatesAutoresizingMaskIntoConstraints = false
        ORLabel.topAnchor.constraint(equalTo: LoginButton.bottomAnchor, constant: view32Height * 1).isActive = true
        ORLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ORLabel.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        ORLabel.heightAnchor.constraint(equalToConstant: view32Height).isActive = true
        
        RegisterButton.translatesAutoresizingMaskIntoConstraints = false
        RegisterButton.topAnchor.constraint(equalTo: ORLabel.bottomAnchor, constant: view32Height * 1).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: view32Height).isActive = true
        
        
    }
    
    
    @objc internal func LoginEvent(_ sender: UIButton){
        
        for use in users {
            if use.UserID == UserID.text{
                if use.Password == Password.text{
                    user = use
                }
            }
        }
        
        if user.UserID == nil{
            displayMyAlertMessage(userMessage: "IDかパスワードが一致していません。")
            return
        }
        
        let vc = HomeViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
 
    
    @objc internal func RegisterEvent(_ sender: UIButton){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func displayMyAlertMessage(userMessage: String){
        
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        self.present(myAlert,animated:true, completion:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
