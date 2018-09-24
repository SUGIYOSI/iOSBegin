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
    
    
    let textview: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return textview
    }()
    
    
    let booktitle: UITextField = {
        let textbar = UITextField()
        textbar.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return textbar
    }()
    
    let bookauthor: UITextField = {
        let textbar = UITextField()
        textbar.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return textbar
    }()
    
    
    let importImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        return image
    }()
    
    
    let saveButton: UIButton = {
        let save = UIButton()
        save.backgroundColor = .blue
        save.setTitle("画像を更新する", for: UIControlState.normal)
        save.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControlEvents.touchUpInside)
        return save
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        let view22Width = self.view.frame.size.width / 22
        let view32Height = self.view.frame.size.height / 32
        
        view.backgroundColor = .white
        
        //シリアライズ 処理（Bookers）
        let userDefaults = UserDefaults.standard
        if let storedBookers = userDefaults.object(forKey: "Bookers") as? Data {
            if let unarchiveBookers = NSKeyedUnarchiver.unarchiveObject(with: storedBookers) as? [BookData] {
                Bookers.append(contentsOf: unarchiveBookers)
            }
        }
        
        //Viewの大きさを取得
        let viewWidth = self.view.frame.size.width
        // let viewHeight = self.view.frame.size.height
        
        //NavigationBar関連
        //UINavigationBarを作成
        let myNavBar = UINavigationBar()
        //大きさの指定
        myNavBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: viewWidth, height: 44)
        //タイトル、虫眼鏡ボタンの作成
        let myNavItems = UINavigationItem()
        myNavItems.title = "感想を教えて下さい"
        let rightNavBtn =  UIBarButtonItem(barButtonSystemItem:  .add, target: self, action: #selector(rightBarBtnClicked(sender:)))
        myNavItems.leftBarButtonItem = rightNavBtn
        rightNavBtn.action = #selector(rightBarBtnClicked(sender:))
        myNavItems.rightBarButtonItem = rightNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
        let leftNavBtn =  UIBarButtonItem(barButtonHiddenItem: .Back, target: self, action: #selector(leftBarBtnClicked(sender:)))
        leftNavBtn.action = #selector(leftBarBtnClicked(sender:))
        myNavItems.leftBarButtonItem = leftNavBtn;
        myNavBar.pushItem(myNavItems, animated: true)
        //ナビゲーションバーをviewに追加
        self.view.addSubview(myNavBar)
        
        
        booktitle.text = Book.BookTitle
        bookauthor.text = Book.Author
        booktitle.delegate = self
        bookauthor.delegate = self
        booktitle.placeholder = "作品名を入力"
        bookauthor.placeholder = "作者名を入力"
        
        booktitle.clearButtonMode = .always
        bookauthor.clearButtonMode = .always
        
        
        if Book.BookImage == nil {
        }else{
            let IMAGE: UIImage? = UIImage(data: Book.BookImage! as Data)
            importImage.image = IMAGE
        }
        
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
        saveButton.topAnchor.constraint(equalTo: importImage.bottomAnchor, constant: view32Height * 2).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: view22Width * 7.5).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -view22Width * 7.5).isActive = true
        saveButton.heightAnchor.constraint(equalTo: booktitle.heightAnchor).isActive = true
        
        
        
        
        
        
    }
    
    
    
    @objc internal func rightBarBtnClicked(sender: UIButton){
        
        Book.BookTitle = booktitle.text
        Book.Author    = bookauthor.text
        
        if textview.text == ""{
            displayMyAlertMessage(userMessage: "感想を入力してください。")
            return
        }
        
        Book.BookViews.updateValue(user.UserID!, forKey: textview.text)
        
        
        for book in Bookers {
            if book.BookTitle == Book.BookTitle {
                book.BookTitle = Book.BookTitle
                book.Author    = Book.Author
                book.BookViews = Book.BookViews
                book.BookImage = Book.BookImage
            }
        }
        
        
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: Bookers)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "Bookers")
        userDefaults.synchronize()
        
        let vc = BookViewController()
        vc.Books = Book
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
        
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
        
        dismiss(animated: true, completion: nil)
    }
    
    func displayMyAlertMessage(userMessage: String){
        
        let myAlert = UIAlertController(title:"警告", message: userMessage, preferredStyle:  UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        self.present(myAlert,animated:true, completion:nil)
        
    }
    
    
    
    @objc internal func leftBarBtnClicked(sender: UIButton){
        
        let vc = BookViewController()
        vc.Books = Book
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}





