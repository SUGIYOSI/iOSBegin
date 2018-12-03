import UIKit


class LoginViewController: UIViewController , UITextFieldDelegate{
    
    var users = [User()]
    var user  = User()

    //UI部品
    let UserID: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    let Password: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    let LoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.italicSystemFont(ofSize: 40)
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
    
    let LoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 255/255, green: 110/255, blue: 134/255, alpha: 1)
        button.setTitle("Login", for: UIControl.State.normal)
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 7, height: 7)
        button.addTarget(self, action: #selector(LoginEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let RegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 89/255, green: 172/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 7, height: 7)
        button.setTitle("Register", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(RegisterEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1) 
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
        UserID.placeholder = "UserIDを入力"
        Password.placeholder = "Passwordを入力"
        UserID.clearButtonMode = .always
        Password.clearButtonMode = .always
        
        view.addSubview(UserID)
        view.addSubview(UserIDLabel)
        view.addSubview(LoginLabel)
        view.addSubview(Password)
        view.addSubview(PasswordLabel)
        view.addSubview(RegisterButton)
        view.addSubview(LoginButton)
        
        //AutoLayout
        LoginLabel.translatesAutoresizingMaskIntoConstraints = false
        LoginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view32Height * 3).isActive = true
        LoginLabel.widthAnchor.constraint(equalToConstant: view22Width * 10).isActive = true
        LoginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginLabel.heightAnchor.constraint(equalToConstant: view32Height * 5).isActive = true
        
        UserIDLabel.translatesAutoresizingMaskIntoConstraints = false
        UserIDLabel.topAnchor.constraint(equalTo: LoginLabel.bottomAnchor, constant: view32Height * 2).isActive = true
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
        LoginButton.topAnchor.constraint(equalTo: Password.bottomAnchor, constant: view32Height * 2.5).isActive = true
        LoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginButton.widthAnchor.constraint(equalToConstant: view22Width * 9).isActive = true
        LoginButton.heightAnchor.constraint(equalToConstant: view32Height * 2).isActive = true
        
        RegisterButton.translatesAutoresizingMaskIntoConstraints = false
        RegisterButton.topAnchor.constraint(equalTo: LoginButton.bottomAnchor, constant: view32Height * 3).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: view22Width * 5).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
    }
    
    @objc func LoginEvent(_ sender: UIButton){
        //ログインできるかどうか調べる
        for use in users {
            if use.UserID == UserID.text{
                if use.Password == Password.text{
                    user = use
                }
            }
        }
        //ログインできなかった場合
        if user.UserID == nil{
            displayMyAlertMessage(userMessage: "IDかパスワードが一致していません。")
            return
        }
        //ユーザー情報をシングルトンに保存してホーム画面に戻る
        NowUser.shared.nowuser = user
        dismiss(animated: true)
    }
    
    //登録画面へ
    @objc internal func RegisterEvent(_ sender: UIButton){
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    //アラートメッセージのメソッド
    func displayMyAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler:nil)
        myAlert.addAction(okAction);
        self.present(myAlert,animated:true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
