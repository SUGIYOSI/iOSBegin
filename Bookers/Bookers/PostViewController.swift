//
//  PostViewController.swift
//  Bookers
//
//  Created by 杉山佳史 on 2018/09/19.
//  Copyright © 2018年 SUGIYOSI. All rights reserved.
//

import UIKit

class PostViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate{
    //BookData型の配列,Bookersを宣言
    var Bookers = [BookData]()
    ////BookData型のObjectを宣言
    var Book = BookData()
    var user  = User()
    var swich: Bool = true
    var turn: Bool = true
    
    let SafeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1) 
        return view
    }()
    
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
        let save = UIButton()
        save.backgroundColor = UIColor(red: 89/255, green: 172/255, blue: 255/255, alpha: 1)
        save.setTitle("画像を更新する", for: UIControlState.normal)
        save.layer.cornerRadius = 12
        save.layer.shadowOpacity = 0.5
        save.layer.shadowRadius = 5
        save.layer.shadowColor = UIColor.black.cgColor
        save.layer.shadowOffset = CGSize(width: 7, height: 7)
        save.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControlEvents.touchUpInside)
        return save
        
    }()

    override func viewWillAppear(_ animated: Bool) {
        if turn == true{
            importImage.image  = nil
            textview.text = ""
            booktitle.text = ""
            bookauthor.text = ""
            Book = BookData()
            Book.BookImage = nil
        }
        turn = true
        Bookers.removeAll()
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        user = NowUser.shared.nowuser
        
        if Book.BookImage == nil {
            importImage.image = UIImage(named: "NoImage")
        }else{
            let IMAGE: UIImage? = UIImage(data: Book.BookImage! as Data)
            importImage.image = IMAGE
        }
        
         importImage.setNeedsLayout()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        let view22Width = self.view.frame.size.width / 22
        let view32Height = self.view.frame.size.height / 32
        
        view.backgroundColor = .white
        let viewWidth = self.view.frame.size.width
        //UINavigationBarを作成
        let myNavBar = UINavigationBar()
        myNavBar.isTranslucent = false
        myNavBar.barTintColor = UIColor(red: 173/255, green: 247/255, blue: 181/255, alpha: 1)
        myNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        let myNavItems = UINavigationItem()
        myNavItems.title = "感想を教えて下さい"
        let rightNavBtn =  UIBarButtonItem(barButtonSystemItem:  .add, target: self, action: #selector(rightBarBtnClicked(sender:)))
        myNavItems.leftBarButtonItem = rightNavBtn
        rightNavBtn.action = #selector(rightBarBtnClicked(sender:))
        myNavItems.rightBarButtonItem = rightNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        self.view.addSubview(myNavBar)
        
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
        
        
        view.addSubview(SafeView)
        SafeView.translatesAutoresizingMaskIntoConstraints = false
        SafeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        SafeView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        SafeView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
        
    }
    
    
    
    @objc internal func rightBarBtnClicked(sender: UIButton){
        for book in Bookers {
            if book.BookTitle == booktitle.text{
                for bookviews in book.BookViews {
                    if bookviews.value == user.UserID{
                      displayMyAlertMessage(userMessage: "１つの本に１つの投稿しか出来ません")
                        return
                    }
                    
                    if bookviews.key == textview.text {
                        displayMyAlertMessage(userMessage: "同じ内容の投稿はできません")
                        return
                        
                    }
                }
            }
        }
        
        if textview.text == "" || booktitle.text == "" || bookauthor.text == ""{
            displayMyAlertMessage(userMessage: "全て入力してください。")
            return
        }
    
        Book.BookTitle = booktitle.text
        Book.Author    = bookauthor.text
        
        for book in Bookers {
            if book.BookTitle == Book.BookTitle {
                book.BookTitle = Book.BookTitle
                book.Author    = Book.Author
                book.BookViews.updateValue(user.UserID!, forKey: textview.text)
                book.BookImage = Book.BookImage
                swich = false
            }
        }
        
        if swich == true {
            Book.BookViews.updateValue(user.UserID!, forKey: textview.text)
            Bookers.append(Book)
        }
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "Bookers")
        userDefaults.synchronize()
    
        swich = true
        textview.text = ""
        booktitle.text = ""
        bookauthor.text = ""
        importImage.image  = nil
        tabBarController?.selectedIndex = 0
        
    }
    
    
    @objc func buttonEvent(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            importImage.image = image
            let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
            Book.BookImage = imageData
        }
        else
        {
            //ErrorMesseage
        }
        
        turn = false
        dismiss(animated: true, completion: nil)
    }
    
    
    func displayMyAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title:"警告", message: userMessage, preferredStyle:  UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        self.present(myAlert,animated:true, completion:nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
