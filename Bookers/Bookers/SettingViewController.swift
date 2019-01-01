import UIKit

class SettingViewController: UIViewController , UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var users = [User()]
    var user  = User()
    
    let Email: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    let UserID: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 158/255, green: 148/255, blue: 247/255, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.isEnabled = false
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
    
    let rePassword: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    let EmailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
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
    
    let rePasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Repeat Passoword"
        return label
    }()
    
    
    let UserLabel: UILabel = {
        let label = UILabel()
        label.text = "ユーザー情報"
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        return label
    }()
    
    let reloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 255/255, green: 110/255, blue: 134/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.setTitle("更新", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(updateUser(_:)), for: UIControl.Event.touchUpInside)
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
        button.setTitle("画像投稿", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(postimage(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 7, height: 7)
        button.setTitle("Logout", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(logout(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let importImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 40
        image.layer.masksToBounds = true
        return image
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        if let storedusers = userDefaults.object(forKey: "users") as? Data {
            if let unarchiveusers = NSKeyedUnarchiver.unarchiveObject(with: storedusers) as? [User] {
                users.append(contentsOf: unarchiveusers)
            }
        }
        setView()
        user = NowUser.shared.nowuser
        view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1) 
        let view22Width = self.view.frame.size.width / 22
        let view32Height = self.view.frame.size.height / 32
        
        view.addSubview(UserID)
        view.addSubview(Password)
        view.addSubview(rePassword)
        view.addSubview(Email)
        view.addSubview(importImage)
        view.addSubview(UserIDLabel)
        view.addSubview(UserLabel)
        view.addSubview(PasswordLabel)
        view.addSubview(rePasswordLabel)
        view.addSubview(EmailLabel)
        view.addSubview(RegisterButton)
        view.addSubview(reloadButton)
        view.addSubview(logoutButton)
        
        //Auto Layout
        UserLabel.translatesAutoresizingMaskIntoConstraints = false
        UserLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view32Height * 3).isActive = true
        UserLabel.widthAnchor.constraint(equalToConstant: view22Width * 5).isActive = true
        UserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        UserLabel.heightAnchor.constraint(equalToConstant: view32Height * 2).isActive = true
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.topAnchor.constraint(equalTo: UserLabel.topAnchor).isActive = true
        logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: view22Width * 2).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        logoutButton.heightAnchor.constraint(equalTo: UserLabel.heightAnchor).isActive = true
        
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.topAnchor.constraint(equalTo: UserLabel.topAnchor).isActive = true
        reloadButton.leadingAnchor.constraint(equalTo: UserLabel.trailingAnchor ,constant: view22Width * 3).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: view22Width * 4).isActive = true
        reloadButton.heightAnchor.constraint(equalTo: UserLabel.heightAnchor).isActive = true
        
        EmailLabel.translatesAutoresizingMaskIntoConstraints = false
        EmailLabel.topAnchor.constraint(equalTo: UserLabel.bottomAnchor, constant: view32Height * 2).isActive = true
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
        
        importImage.translatesAutoresizingMaskIntoConstraints = false
        importImage.topAnchor.constraint(equalTo:rePassword.bottomAnchor, constant: view32Height * 1.0).isActive = true
        importImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: view22Width * 5.5).isActive = true
        importImage.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -view22Width * 5.5).isActive = true
        importImage.heightAnchor.constraint(equalToConstant: view32Height * 4).isActive = true
        
        RegisterButton.translatesAutoresizingMaskIntoConstraints = false
        RegisterButton.topAnchor.constraint(equalTo: importImage.bottomAnchor, constant: view32Height * 1).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: view22Width * 6).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: view32Height * 2).isActive = true
        
    }
    
    
    func setView(){
        Password.delegate = self
        Email.delegate = self
        rePassword.delegate = self
        Password.placeholder = "Passwordを入力"
        Email.placeholder = "Emailを入力"
        rePassword.placeholder = "Passwordを再入再力"
        Password.clearButtonMode = .always
        Email.clearButtonMode = .always
        rePassword.clearButtonMode = .always
        user = NowUser.shared.nowuser
        Email.text = user.Email
        UserID.text = user.UserID
        Password.text = user.Password
        rePassword.text = user.Password
        if let unwrapedUserImage = user.UserImage{
            importImage.image = UIImage(data: unwrapedUserImage as Data)
        }
    
        view.addSubview(UserID)
        view.addSubview(Password)
        view.addSubview(rePassword)
        view.addSubview(Email)
        view.addSubview(importImage)
    }
    
    @objc func updateUser(_ sender: UIButton){
        if(Password.text == "" || rePassword.text == "" || Email.text == ""){
            displayMyAlertMessage(userMessage: "全てのフォームに入力してください。")
            return
        }
        if(Password.text != rePassword.text){
            displayMyAlertMessage(userMessage: "パスワードが一致していません。")
            return
        }
        
        for use in users {
            if use.UserID == user.UserID{
                use.Email     = Email.text
                use.Password  = Password.text
                use.UserImage = user.UserImage
                NowUser.shared.nowuser = use
            }
        }
        
        NowUser.shared.nowuser = user
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: users)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "users")
        userDefaults.synchronize()
        tabBarController?.selectedIndex = 0
    }
    
    
    @objc func postimage (_ sender: UIButton){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            importImage.image = image
            let imageData: NSData? = image.pngData() as NSData?
            user.UserImage = imageData
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func logout (_ sender: UIButton){
        let nc = UINavigationController(rootViewController: LoginViewController())
        self.present(nc, animated: true, completion: nil)
        tabBarController?.selectedIndex = 0
    }
    
    func displayMyAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler:nil)
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
