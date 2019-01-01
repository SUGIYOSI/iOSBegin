import UIKit

class PostViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate{
    
    var Bookers = [BookData]()
    var Book = BookData()
    var user  = User()
    //newBookCheckSwichは新しい本についての投稿かどうかを判別する
    var newBookCheckSwich: Bool = true
    //importImageSwichはviewWillAppearを使った時の状況に応じて色々な値を初期化するかどうかを判別する
    var importImageSwich: Bool = true
    
    let textview: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textview.layer.cornerRadius = 10
        textview.layer.masksToBounds = true
        return textview
    }()
    
    let booktitle: UITextField = {
        let textbar = UITextField()
        textbar.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textbar.layer.cornerRadius = 10
        textbar.layer.masksToBounds = true
        return textbar
    }()
    
    let bookauthor: UITextField = {
        let textbar = UITextField()
        textbar.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textbar.layer.cornerRadius = 10
        textbar.layer.masksToBounds = true
        return textbar
    }()
    
    let importImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 30
        image.layer.masksToBounds = true
        return image
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 89/255, green: 172/255, blue: 255/255, alpha: 1)
        button.setTitle("画像を更新する", for: UIControl.State.normal)
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 7, height: 7)
        button.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        if importImageSwich == true{
            resetValue()
        }
        importImageSwich = true
        user = NowUser.shared.nowuser
        if let unwrapedBookImage = Book.BookImage{
            importImage.image = UIImage(data: unwrapedBookImage as Data)
        }
        importImage.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let view22Width = self.view.frame.size.width / 22
        let view32Height = self.view.frame.size.height / 32
        
        //NavigationBar
        self.navigationItem.title = "感想を教えて下さい"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        let rightAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarBtnClicked(sender:)))
        self.navigationItem.rightBarButtonItem = rightAddButton
        
        booktitle.text = Book.BookTitle
        bookauthor.text = Book.Author
        booktitle.delegate = self
        bookauthor.delegate = self
        booktitle.placeholder = "作品名を入力"
        bookauthor.placeholder = "作者名を入力"
        booktitle.clearButtonMode = .always
        bookauthor.clearButtonMode = .always
        
        view.addSubview(textview)
        view.addSubview(booktitle)
        view.addSubview(bookauthor)
        view.addSubview(importImage)
        view.addSubview(saveButton)
        
        //Auto Layout仕様
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.topAnchor.constraint(equalTo: view.topAnchor, constant: view32Height * 5).isActive = true
        textview.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: view22Width).isActive = true
        textview.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -view22Width).isActive = true
        textview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textview.heightAnchor.constraint(equalToConstant: view32Height * 6).isActive = true
        
        booktitle.translatesAutoresizingMaskIntoConstraints = false
        booktitle.topAnchor.constraint(equalTo: textview.bottomAnchor, constant: view32Height * 2).isActive = true
        booktitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        booktitle.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: view22Width * 5.5).isActive = true
        booktitle.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -view22Width * 5.5).isActive = true
        booktitle.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
        
        bookauthor.translatesAutoresizingMaskIntoConstraints = false
        bookauthor.topAnchor.constraint(equalTo: booktitle.bottomAnchor, constant: view32Height * 1.5).isActive = true
        bookauthor.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: view22Width * 5.5).isActive = true
        bookauthor.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -view22Width * 5.5).isActive = true
        bookauthor.heightAnchor.constraint(equalTo: booktitle.heightAnchor).isActive = true
        bookauthor.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        importImage.translatesAutoresizingMaskIntoConstraints = false
        importImage.topAnchor.constraint(equalTo:bookauthor.bottomAnchor, constant: view32Height * 2.0).isActive = true
        importImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: view22Width * 3.5).isActive = true
        importImage.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -view22Width * 3.5).isActive = true
        importImage.heightAnchor.constraint(equalToConstant: view32Height * 6).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: importImage.bottomAnchor, constant: view32Height * 1).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: view22Width * 7).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -view22Width * 7).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: view32Height * 1.5).isActive = true
    }
    
    @objc internal func rightBarBtnClicked(sender: UIButton){
        for book in Bookers {
            if book.BookTitle == booktitle.text{
                for bookviews in book.BookViews {
                    //同じ人が同じ本に複数の投稿することを拒否する
                    if(bookviews.value == user.UserID){
                      displayMyAlertMessage(userMessage: "１つの本に１つの投稿しか出来ません")
                        return
                    }
                    //同じ内容の投稿は拒否する
                    if(bookviews.key == textview.text){
                        displayMyAlertMessage(userMessage: "同じ内容の投稿はできません")
                        return
                    }
                }
            }
        }
        
        if(textview.text == "" || booktitle.text == "" || bookauthor.text == ""){
            displayMyAlertMessage(userMessage: "全て入力してください。")
            return
        }
    
        Book.BookTitle = booktitle.text
        Book.Author    = bookauthor.text
        
        //新しい本についてのレビューが投稿されたか、既にある本にレビューが投稿されたかを判別し、対応する
        for book in Bookers {
            if book.BookTitle == Book.BookTitle {
                book.BookTitle = Book.BookTitle
                book.Author    = Book.Author
                if let unwrapedUserID = user.UserID {
                    book.BookViews.updateValue(unwrapedUserID, forKey: textview.text)
                }
                book.BookImage = Book.BookImage
                newBookCheckSwich = false
            }
        }
        if newBookCheckSwich == true {
            if let unwrapedUserID = user.UserID {
                Book.BookViews.updateValue(unwrapedUserID, forKey: textview.text)
            }
            Bookers.append(Book)
        }
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "Bookers")
        userDefaults.synchronize()
    
        newBookCheckSwich = true
        tabBarController?.selectedIndex = 0
    }
    
    func resetValue(){
        textview.text = ""
        booktitle.text = ""
        bookauthor.text = ""
        Book = BookData()
        Bookers.removeAll()
        Book.BookImage = UIImage(named: "NoImage")?.pngData() as NSData?
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
    }
    
    @objc func buttonEvent(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            importImage.image = image
            let imageData: NSData? = image.pngData() as NSData?
            Book.BookImage = imageData
        }
        importImageSwich = false
        dismiss(animated: true, completion: nil)
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
