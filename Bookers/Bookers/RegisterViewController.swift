//
//  RegisterViewController.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/09/19.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController , UITextFieldDelegate{
    
    var users = [User()]
    var user  = User()
    
    
    let Email: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return textfield
    }()
    
    
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
    
    let rePassword: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return textfield
    }()
    
    
    
    let EmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email:"
        return label
    }()
    
    let UserIDLabel: UILabel = {
        let label = UILabel()
        label.text = "UserID:"
        return label
    }()
    
    let PasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        return label
    }()
    
    let rePasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Repeat Passoword:"
        return label
    }()
    
    
    let RegisterLabel: UILabel = {
        let label = UILabel()
        label.text = "Register"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let LoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.setTitle("Login", for: UIControlState.normal)
        button.addTarget(self, action: #selector(Login(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let RegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.setTitle("Register", for: UIControlState.normal)
        button.addTarget(self, action: #selector(Register(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        let view22Width = self.view.frame.size.width / 22
        let view32Height = self.view.frame.size.height / 32
        
        let userDefaults = UserDefaults.standard
        if let storedusers = userDefaults.object(forKey: "users") as? Data {
            if let unarchiveusers = NSKeyedUnarchiver.unarchiveObject(with: storedusers) as? [User] {
                users.append(contentsOf: unarchiveusers)
            }
        }
        
        
        UserID.delegate = self
        Password.delegate = self
        Email.delegate = self
        rePassword.delegate = self
        UserID.placeholder = "UserIDを入力"
        Password.placeholder = "Passwordを入力"
        Email.placeholder = "Emailを入力"
        rePassword.placeholder = "Passwordを再入再力"
        
        UserID.clearButtonMode = .always
        Password.clearButtonMode = .always
        Email.clearButtonMode = .always
        rePassword.clearButtonMode = .always
        
        
        view.addSubview(UserID)
        view.addSubview(UserIDLabel)
        view.addSubview(RegisterLabel)
        view.addSubview(Password)
        view.addSubview(PasswordLabel)
        view.addSubview(rePassword)
        view.addSubview(rePasswordLabel)
        view.addSubview(Email)
        view.addSubview(EmailLabel)
        view.addSubview(RegisterButton)
        view.addSubview(LoginButton)
        
        
        //Auto Layout
        RegisterLabel.translatesAutoresizingMaskIntoConstraints = false
        RegisterLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view32Height * 3).isActive = true
        RegisterLabel.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        RegisterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterLabel.heightAnchor.constraint(equalToConstant: view32Height * 2).isActive = true
        
        LoginButton.translatesAutoresizingMaskIntoConstraints = false
        LoginButton.topAnchor.constraint(equalTo: RegisterLabel.topAnchor).isActive = true
        LoginButton.leadingAnchor.constraint(equalTo: RegisterLabel.trailingAnchor ,constant: view22Width * 4).isActive = true
        LoginButton.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        LoginButton.heightAnchor.constraint(equalTo: RegisterLabel.heightAnchor).isActive = true
        
        EmailLabel.translatesAutoresizingMaskIntoConstraints = false
        EmailLabel.topAnchor.constraint(equalTo: RegisterLabel.bottomAnchor, constant: view32Height * 2).isActive = true
        EmailLabel.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        EmailLabel.leadingAnchor.constraint(equalTo: Email.leadingAnchor).isActive = true
        EmailLabel.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        Email.translatesAutoresizingMaskIntoConstraints = false
        Email.topAnchor.constraint(equalTo: EmailLabel.bottomAnchor).isActive = true
        Email.widthAnchor.constraint(equalToConstant: view22Width * 13).isActive = true
        Email.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Email.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        UserIDLabel.translatesAutoresizingMaskIntoConstraints = false
        UserIDLabel.topAnchor.constraint(equalTo: Email.bottomAnchor).isActive = true
        UserIDLabel.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        UserIDLabel.leadingAnchor.constraint(equalTo: UserID.leadingAnchor).isActive = true
        UserIDLabel.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        UserID.translatesAutoresizingMaskIntoConstraints = false
        UserID.topAnchor.constraint(equalTo: UserIDLabel.bottomAnchor).isActive = true
        UserID.widthAnchor.constraint(equalToConstant: view22Width * 13).isActive = true
        UserID.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        UserID.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        PasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        PasswordLabel.topAnchor.constraint(equalTo: UserID.bottomAnchor).isActive = true
        PasswordLabel.widthAnchor.constraint(equalToConstant: view22Width * 6).isActive = true
        PasswordLabel.leadingAnchor.constraint(equalTo: Password.leadingAnchor).isActive = true
        PasswordLabel.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        Password.translatesAutoresizingMaskIntoConstraints = false
        Password.topAnchor.constraint(equalTo: PasswordLabel.bottomAnchor).isActive = true
        Password.widthAnchor.constraint(equalToConstant: view22Width * 13).isActive = true
        Password.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Password.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        rePasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        rePasswordLabel.topAnchor.constraint(equalTo: PasswordLabel.bottomAnchor, constant: view32Height * 1.5).isActive = true
        rePasswordLabel.widthAnchor.constraint(equalToConstant: view22Width * 10).isActive = true
        rePasswordLabel.leadingAnchor.constraint(equalTo: rePassword.leadingAnchor).isActive = true
        rePasswordLabel.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        rePassword.translatesAutoresizingMaskIntoConstraints = false
        rePassword.topAnchor.constraint(equalTo: rePasswordLabel.bottomAnchor).isActive = true
        rePassword.widthAnchor.constraint(equalToConstant: view22Width * 13).isActive = true
        rePassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rePassword.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        RegisterButton.translatesAutoresizingMaskIntoConstraints = false
        RegisterButton.topAnchor.constraint(equalTo: rePassword.bottomAnchor, constant: view32Height * 2).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: view32Height * 2.5).isActive = true
        
        
        
    }
    
    @objc internal func Login(_ sender: UIButton){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc internal func Register(_ sender: UIButton){
        
        
        
        if(UserID.text == "" || Password.text == "" || rePassword.text == "" || Email.text == ""){
            //アラートメッセージ
            displayMyAlertMessage(userMessage: "全てのフォームに入力してください。")
            return
        }
        
        //パスワード一致確認
        if(Password.text != rePassword.text)
        {
            displayMyAlertMessage(userMessage: "パスワードが一致していません。")
            return
        }
        
        user.Email = Email.text
        user.UserID = UserID.text
        user.Password = Password.text
        users.insert(user, at: 0)
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: users)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "users")
        userDefaults.synchronize()
        
        
        let vc = HomeViewController()
        vc.user = user
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
